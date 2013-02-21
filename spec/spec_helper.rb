# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
spec_root = File.expand_path('..', __FILE__)
require File.expand_path("dummy/config/environment.rb",  spec_root)

require 'pry'
require 'rspec/rails'
require 'mongoid-rspec'
require 'database_cleaner'
require 'shoulda-matchers'
require 'factory_girl_rspec'

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include ModelAbstraction
  config.include Devise::TestHelpers, :type => :controller
  config.include ::Mongoid::Matchers
    
  config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.render_views
end
