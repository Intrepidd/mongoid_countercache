require 'mongoid'

class Post
  include Mongoid::Document

  has_many :comments
end
