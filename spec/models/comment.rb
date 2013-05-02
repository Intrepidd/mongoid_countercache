require 'mongoid'
require 'mongoid_counter_cache'

class Comment
  include Mongoid::Document
  include Mongoid::CounterCache

  belongs_to :post

  field :mark, :type => Integer, :default => 5

  counter_cache :post, :variants => {
    :positive => lambda { mark > 8},
    :negative => lambda { mark < 3}
  }
end
