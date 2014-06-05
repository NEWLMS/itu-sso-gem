ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + '/support/config/boot'
require 'rspec/rails'

require 'faraday'

# Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
end

load File.dirname(__FILE__) + '/schema.rb'
require File.dirname(__FILE__) + '/support/models/user'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
end
