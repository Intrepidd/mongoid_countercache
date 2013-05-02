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

        after_create do
          parent = self.send(relation_name)
          if parent && parent[field_name]
            parent[field_name] += 1
          end
        end

        after_destroy do
          parent = self.send(relation_name)
          if parent && parent[field_name]
            parent[field_name] -= 1
          end
        end

      end
    end

  end
end
