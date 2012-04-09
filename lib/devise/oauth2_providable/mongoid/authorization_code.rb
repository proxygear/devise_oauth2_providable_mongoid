module Devise
  module Oauth2Providable
    module Mongoid
      module AuthorizationToken
        extend ActiveSupport::Concern

        def self.included base
          base.class_eval do
            include Mongoid::Document

            include Oauth2Providable::Behaviors::AuthorizationToken

            field :token,       type: String, unique: true
            field :expires_at,  type: DateTime

            timestamps

            index :token
            index :expires_at
            index :user_id
            index :client_id
          end
        end
      end
    end
  end
end