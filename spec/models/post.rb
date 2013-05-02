require 'mongoid'

class Post
  include Mongoid::Document

  field :comment_count, :type => Integer, :default => 0
  field :comment_count_positive, :type => Integer, :default => 0
  field :comment_count_negative, :type => Integer, :default => 0
  field :like_count, :type => Integer, :default => 0
  field :custom_field_name, :type => Integer, :default => 0


  has_many :comments
  embeds_many :likes
end
