module Devise
  module Oauth2Providable
    module Mongoid
      module RefreshToken
        extend ActiveSupport::Concern

        def self.included base
          base.class_eval do
            include ::Mongoid::Document
            include ::Mongoid::Timestamps

            field :token,       type: String
            field :expires_at,  type: DateTime

            index({ token: 1 }, {unique: true})
            index({ expires_at: 1 })
            index({ user_id: 1})

            validates_uniqueness_of :token

            index({ Oauth2Providable.ABSTRACT(:client_sym_id) => 1})

            include Oauth2Providable::Behaviors::RefreshToken

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