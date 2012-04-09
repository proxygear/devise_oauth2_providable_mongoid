module Devise
  module Oauth2Providable
    module Mongoid
      module RefreshToken
        extend ActiveSupport::Concern

        def self.included base
          base.class_eval do
            include Mongoid::Document

            include Oauth2Providable::Behaviors::RefreshToken

            field :token,     type: String, unique: true
            field :datetime,  type: Datetime

            timestamps
        
            index :token, :expires_at, :user_id, :client_id
          end
        end
      end
    end
  end
end