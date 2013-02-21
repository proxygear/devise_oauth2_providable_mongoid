module Devise
  module Oauth2Providable
    module Mongoid
      module AccessToken
        extend ActiveSupport::Concern

        included do
          class_eval do
            include ::Mongoid::Document
            include ::Mongoid::Timestamps

            field :token,       type: String
            field :expires_at,  type: DateTime

            index({user_id: 1})
            index({expires_at: 1})
            index({token: 1}, {unique: true})
            index({Devise::Oauth2Providable.ABSTRACT(:client_sym_id) => 1})

            validates_uniqueness_of :token

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