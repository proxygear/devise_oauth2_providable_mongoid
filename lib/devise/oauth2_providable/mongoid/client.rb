module Devise
  module Oauth2Providable
    module Mongoid
      module Client
        extend ActiveSupport::Concern

        def self.included base
          base.class_eval do
            include ::Mongoid::Document
            include ::Mongoid::DefaultScope
            include ::Mongoid::Timestamps

            field :name,            type: String
            field :redirect_uri,    type: String
            field :website,         type: String
            field :secret,          type: String
            field :app_identifier,  type: String, unique: true
            
            index :app_identifier
            
            include Oauth2Providable::Behaviors::Client
            
            extend ClassMethods
          end
        end
        
        module ClassMethods
          def find_by_app_identifier bla
            where(:app_identifier => bla).first
          end
        end
      end
    end
  end
end