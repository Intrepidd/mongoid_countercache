require 'mongoid'

class Post
  include Mongoid::Document

  has_many :comments
  embeds_many :likes
end
