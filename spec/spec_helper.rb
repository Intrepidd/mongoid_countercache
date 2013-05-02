require 'rspec'
require 'bundler/setup'
require 'mongoid'


Mongoid.configure do |config|
  config.connect_to("mongoid_counter_cache")
end

RSpec.configure do |c|
  c.mock_with :rspec

  c.after(:all) do
    Mongoid.purge!
  end
end

