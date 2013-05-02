require 'mongoid'

class Like
  include Mongoid::Document
  include Mongoid::CounterCache

  embedded_in :post

  counter_cache :post
end
