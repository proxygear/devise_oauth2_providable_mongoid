module Devise
  module Oauth2Providable
    module Mongoid
      module AccessToken
        extend ActiveSupport::Concern

        def self.included base
          base.class_eval do
            include Mongoid::Document

            include Oauth2Providable::Behaviors::AccessToken

            field :token,     type: String, unique: true
            field :expires_at type: DateTime

            timestamps

            index :user_id
            index :client_id
            index :expires_at
            index :token
          end
        end
      end
    end
  end
end