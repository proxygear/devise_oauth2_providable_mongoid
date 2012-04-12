module Devise
  module Oauth2Providable
    module Mongoid
      module AccessToken
        extend ActiveSupport::Concern

        def self.included base
          base.class_eval do
            include ::Mongoid::Document
            include ::Mongoid::DefaultScope
            include ::Mongoid::Timestamps
            
            
            field :token,       type: String, unique: true
            field :expires_at,  type: DateTime

            index :user_id
            index Devise::Oauth2Providable.ABSTRACT(:client_sym_id)
            index :expires_at
            index :token
            
            include Devise::Oauth2Providable::Behaviors::AccessToken
            
            extend ClassMethods
          end
        end
        
        module ClassMethods
          def find_by_token token
            where(:token => token).first
          end
        end
      end
    end
  end
end