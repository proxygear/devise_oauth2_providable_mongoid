class User
  include ::Mongoid::Document
  
  devise(
    :database_authenticatable,
    :oauth2_providable,
    :oauth2_password_grantable,
    :oauth2_refresh_token_grantable,
    :oauth2_authorization_code_grantable
    # ,
    # :recoverable,
    # :rememberable,
    # :trackable,
    # :validatable
  )
  
  #attr_accessor :sign_in_count
  
  field :email,               type: String
  field :encrypted_password,  type: String
end
