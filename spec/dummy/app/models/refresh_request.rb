class RefreshRequest
  include Mongoid::Document
  include Devise::Oauth2Providable::Mongoid::RefreshToken
end
