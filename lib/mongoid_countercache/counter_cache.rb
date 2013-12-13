module Mongoid
  module CounterCache

    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      # Defines a counter cache on the given relation
      #
      # @param [Class] relation_name The name of the parent relation on which to create the cache
      # @param [Hash] options The options hash
      # @option options [String, Symbol] :field_name The name of the field in the parent document
      # @option options [Hash] :variants A hash with a variant name in key and a lambda / proc in value
      def counter_cache(relation_name, options = {})
        field_name = (options[:field_name] || "#{self.to_s.demodulize.underscore}_count").to_s

        options[:variants].to_a.each do |key,proc|
          variant_name = "#{field_name}_#{key.to_s.strip}"

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
      parent.inc(field => inc) if proc.nil? || proc.bind(self).call
    end

  end
end
