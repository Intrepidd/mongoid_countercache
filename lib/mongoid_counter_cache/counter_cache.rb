module Mongoid
  module CounterCache

    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def counter_cache(relation_name, options = {})
      end
    end

  end
end
