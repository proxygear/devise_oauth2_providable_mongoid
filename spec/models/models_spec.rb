require 'spec_helper'

describe Devise::Oauth2Providable::Models do
  let (:expectations) do
    {
      :access_token => {
        :class => GrantAccessToken,
        :sym => :grant_access_token,
        :plur => :grant_access_tokens
      },
      :authorization_code => {
        :class => Authorization,
        :sym => :authorization,
        :plur => :authorizations
      },
      :client => {
        :class => ClientApp,
        :sym => :client_app,
        :plur => :client_apps
      },
      :refresh_token => {
        :class => RefreshRequest,
        :sym => :refresh_request,
        :plur => :refresh_requests
      }
    }
  end
  
  let (:models) { Devise::Oauth2Providable.models }

  Devise::Oauth2Providable::Models::ABSTRACT_NAMES.each do |abtract_name|
    describe "abtract #{abtract_name}" do
      let (:abtract_name) { abtract_name }
      
      it("has a model") do
        model = models.send(abtract_name)
        assert model.kind_of?(Class), "model is : #{model.inspect}"
        assert_equal expectations[abtract_name][:class], model
      end
      
      it("has a symbol") do
        symbol = models.send("#{abtract_name}_sym")
        assert symbol.kind_of?(Symbol), "symbol received : #{symbol}"
        assert_equal expectations[abtract_name][:sym], symbol
      end
      
      it("has a symbol id") do
        symbol = models.send("#{abtract_name}_sym_id")
        assert symbol.kind_of?(Symbol), "symbol received : #{symbol}"
      end
      
      it "has a plural symbol" do
        assert_equal models.send("#{abtract_name}_sym").to_s.pluralize,
          models.send("#{abtract_name}_plur").to_s
        assert models.send("#{abtract_name}_plur").kind_of?(Symbol)
        assert_equal expectations[abtract_name][:plur], models.send("#{abtract_name}_plur")
      end
    end
  end
end
