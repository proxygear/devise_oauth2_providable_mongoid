class Devise::Oauth2Providable::TokensController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token, :only => :create

  def create
    @refresh_token = oauth2_current_refresh_token
    @refresh_token ||= oauth2_current_client.send(Devise::Oauth2Providable.ABSTRACT(:refresh_token_plur)).create!(:user => current_user)
    @access_token = @refresh_token.send(Devise::Oauth2Providable.ABSTRACT(:access_token_plur)).create!(
      Devise::Oauth2Providable.ABSTRACT(:client_sym) => oauth2_current_client,
      :user => current_user
    )
    render :json => @access_token.token_response
  end
  private
  def oauth2_current_client
   env[Devise::Oauth2Providable::CLIENT_ENV_REF]
  end
  def oauth2_current_refresh_token
    env[Devise::Oauth2Providable::REFRESH_TOKEN_ENV_REF]
  end
end
