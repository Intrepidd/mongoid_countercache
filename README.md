# MongoidCounterCache

This gem is used to maintain a cached counter of an object's children, this avoids N + 1 queries issues when doing a ``count`` in a loop.

This is basically an implementation of ActiveRecord counter cache for Mongoid.

## Installation

Add this line to your application's Gemfile:

    gem 'mongoid_counter_cache'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid_counter_cache

## Usage

Include ``Mongoid::CounterCache`` into your embedded or referenced model :

    class Comment
      include Mongoid::Document
      include Mongoid::CounterCache

      belongs_to :post

      counter_cache :post
    end

Heads up ! Be sure to require the children document in the parent file, so there is no dependency issues :

    require 'comment'

    class Post
      has_many :comments
    end

Use the count method in the parent model :

    Comment.first.post_count

You can rename the field used for storing the counter

    counter_cache :post, :field_name => 'post_counter'

Then :

    Comment.first.post_counter

## Variants

Sometimes you want to keep a count but only for a subset of your document.

Fortunately, mongoid_counter_cache allows to keep alternative counters :

    class Comment
      include Mongoid::Document
      include Mongoid::CounterCache

      field :mark, :type => Integer

      belongs_to :post

      counter_cache :post, :variants => {
        :positive => lambda { mark >= 8 },
        :positive => lambda { mark <= 2 }
      }
    end

You just have to suffix the count method to get the number of positive comments here :

    Comment.first.post_count_positive
    Comment.first.post_count_negative

It's even magic ! If you update the comment so it doesn't belongs to the same counter, the counters will be updated accordingly.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
