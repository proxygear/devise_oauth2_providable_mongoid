source "http://rubygems.org"

# Specify your gem's dependencies in the .gemspec
gemspec

gem 'devise_oauth2_providable', :git => 'https://github.com/proxygear/devise_oauth2_providable.git', :branch => :mongo_mapper_orm

gem "mongoid", "~> 2.4"
gem "bson_ext", "~> 1.5"
gem "devise"

gem 'debugger', group: [:development, :test]
gem "mongoid-rspec", ">= 1.4.1", git: "https://github.com/evansagge/mongoid-rspec.git", group: [:development, :test]

group :test do
    
    gem 'rb-fsevent'
    gem 'guard-rspec'
    gem 'growl' #grow notification
end