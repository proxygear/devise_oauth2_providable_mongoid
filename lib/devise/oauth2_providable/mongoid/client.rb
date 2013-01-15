module Devise
  module Oauth2Providable
    module Mongoid
      module Client
        extend ActiveSupport::Concern

        def self.included base
          base.class_eval do
            include ::Mongoid::Document
            include ::Mongoid::Timestamps

            field :name,            type: String
            field :redirect_uri,    type: String
            field :website,         type: String
            field :secret,          type: String
            field :app_identifier,  type: String

            index({app_identifier: 1}, {unique: true})

            validates_uniqueness_of :app_identifier

            include Oauth2Providable::Behaviors::Client

            extend ClassMethods
          end
        end
        module ClassMethods
          def find_by_app_identifier id
            where(:app_identifier => id).first
          end
        end
      end
    end
  end
end