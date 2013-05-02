require 'spec_helper'
require 'models/post'
require 'models/comment'

describe 'CounterCache' do

  before(:each) do
    @post = Post.new
    @post.save
  end

  after(:each) do
    Post.destroy_all
    Comment.destroy_all
  end

  context 'No variants' do
    it 'Updates the counter' do
      @post.comments.create
      @post.comment_count.should == 1
      @post.custom_field_name.should == 1

      @post.comments.create
      @post.comment_count.should == 2
      @post.custom_field_name.should == 2

      @post.comments.last.destroy
      @post.comment_count.should == 1
      @post.custom_field_name.should == 1

      @post.comments.last.destroy
      @post.comment_count.should == 0
      @post.custom_field_name.should == 0
    end
  end

  context 'Variants' do
    it 'Updates the counter' do
      @post.comments.create(:mark => 8)
      @post.comment_count.should == 1
      @post.comment_count_positive == 1
      @post.comment_count_negative == 0

      @post.comments.create(:mark => 9)
      @post.comment_count.should == 2
      @post.comment_count_positive == 2
      @post.comment_count_negative == 0

      @post.comments.create(:mark => 1)
      @post.comment_count.should == 3
      @post.comment_count_positive == 2
      @post.comment_count_negative == 1

      @post.comments.last.destroy
      @post.comment_count.should == 2
      @post.comment_count_positive == 2
      @post.comment_count_negative == 0
    end
  end




end
