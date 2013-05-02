module Mongoid
  module CounterCache

    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      # Defines a counter cache on the given relation
      #
      # @param [Class] relation_name The name of the parent relation on which to create the cache
      def counter_cache(relation_name, options = {})
        parent_class = relation_name.to_s.camelize.constantize
        field_name = (options[:field_name] || "#{self.to_s.demodulize.underscore}_count").to_s
        parent_class.class_eval <<-eos
           field :#{field_name}, :type => Integer, :default => 0
        eos

        options[:variants].to_a.each do |key,proc|
          variant_name = "#{field_name}_#{key.to_s.strip}"
          parent_class.class_eval <<-eos
             field :#{variant_name}, :type => Integer, :default => 0
          eos

          after_create { update_parent_counter(self.send(relation_name), variant_name, 1, proc) }
          after_destroy { update_parent_counter(self.send(relation_name), variant_name, -1, proc) }
          after_update { update_parent_counter(self.send(relation_name), variant_name, 1, proc) }

          before_update do
            attributes = self.attributes.dup
            self.changes.each do |change, vals|
              self.attributes[change] = vals.first
            end
            update_parent_counter(self.send(relation_name), variant_name, -1, proc)
            self.attributes = attributes
          end

        end

        after_create { update_parent_counter(self.send(relation_name), field_name, 1) }
        after_destroy { update_parent_counter(self.send(relation_name), field_name, -1) }

      end
    end

    private

    def update_parent_counter(parent, field, inc, proc = nil)
      return unless parent && parent[field]
      parent[field] += inc if proc.nil? || proc.bind(self).call
      parent.save
    end

  end
end
