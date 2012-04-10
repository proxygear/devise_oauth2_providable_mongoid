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

      module ClassMethods        
        def orm_default_scope
          lambda { where(:expires_at.gte => Time.now.utc) }
        end
      end
    end
    
    module Mongoid
      
    end
  end

  module Strategies
    class Oauth2AuthorizationCodeGrantTypeStrategy < Oauth2GrantTypeStrategy
      def grant_type
        'authorization_code'
      end

      def authenticate_grant_type(client)
        client_code = client.send(Devise::Oauth2Providable.ABSTRACT(:authorization_code_plur)).find_by_token(params[:code])
        if code = client_code
          success! code.user
        elsif !halted?
          oauth_error! :invalid_grant, 'invalid authorization code request'
        end
      end
    end
  end
end

Warden::Strategies.add(:oauth2_authorization_code_grantable, Devise::Strategies::Oauth2AuthorizationCodeGrantTypeStrategy)
