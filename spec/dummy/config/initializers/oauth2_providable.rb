Devise::Oauth2Providable.configure_models() do |abstract|
  abstract.client_sym = :client_app
  abstract.refresh_token_sym = :refresh_request
  abstract.authorization_code_sym = :authorization
  abstract.access_token_sym = :grant_access_token
end
