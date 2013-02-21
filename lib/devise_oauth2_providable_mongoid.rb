require 'devise'
require 'devise_oauth2_providable'
require "devise/oauth2_providable/mongoid/version"

Devise::Oauth2Providable::Models::ABSTRACT_NAMES.each do |abstract|
  require "devise/oauth2_providable/mongoid/#{abstract}"
end

module Devise
  module Oauth2Providable
    module ExpirableToken
      extend ActiveSupport::Concern

      included do
        class_eval do
          extend ClassMethods
        end
      end

      module ClassMethods        
        def lambda_not_expired
          lambda { where(:expires_at.gte => Time.now.utc) }
        end
      end
    end

    module Mongoid
      
    end
  end
end
