module Devise
  module Oauth2Providable
    module Mongoid
      module Client
        extend ActiveSupport::Concern

        def self.included base
          base.class_eval do
            include Mongoid::Document

            include Oauth2Providable::Behaviors::Client
            
            field :name,          type: String
            field :redirect_uri,  type: String
            field :website,       type: String
            field :identifier,    type: String, unique: true
            field :secret,        type: String

            index :identifier
          end
        end
      end
    end
  end