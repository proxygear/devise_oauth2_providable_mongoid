require 'spec_helper'

describe Devise::Strategies::Oauth2PasswordGrantTypeStrategy do
  describe 'POST /oauth2/token' do
    describe 'with grant_type=password' do
      context 'with valid params' do
        with :client
        before do
          @user = User.create! :email => 'ryan@socialcast.com', :password => 'testing'

          params = {
            :format => :json,
            :grant_type => 'password',
            :client_id => client.app_identifier,
            :client_secret => client.secret,
            :username => @user.email,
            :password => 'testing'
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 200 }
        it { response.content_type.should == 'application/json' }
        it 'returns json' do
          token = ABSTRACT(:access_token).last
          expected = token.token_response
          response.body.should match_json(expected)
        end
      end
      context 'with valid params and client id/secret in basic auth header' do
        with :client
        before do
          @user = User.create! :email => 'ryan@socialcast.com', :password => 'testing'

          params = {
            :format => :json,
            :grant_type => 'password',
            :username => @user.email,
            :password => 'testing'
          }

          auth_header = ActionController::HttpAuthentication::Basic.encode_credentials client.app_identifier, client.secret
          post '/oauth2/token', params, 'HTTP_AUTHORIZATION' => auth_header
        end
        it { response.code.to_i.should == 200 }
        it { response.content_type.should == 'application/json' }
        it 'returns json' do
          token = ABSTRACT(:access_token).last
          expected = token.token_response
          response.body.should match_json(expected)
        end
      end
      context 'with invalid client id in basic auth header' do
        with :client
        before do
          @user = User.create! :email => 'ryan@socialcast.com', :password => 'testing'
          params = {
            :format => :json,
            :grant_type => 'password',
            :username => @user.email,
            :password => 'testing'
          }
          auth_header = ActionController::HttpAuthentication::Basic.encode_credentials 'invalid client id', client.secret
          post '/oauth2/token', params, 'HTTP_AUTHORIZATION' => auth_header
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json'  }
        it 'returns json' do
          expected = {
            :error_description => "invalid client credentials",
            :error => "invalid_client"
          }
          response.body.should match_json(expected)
        end
      end
      context 'with invalid client secret in basic auth header' do
        with :client
        before do
          @user = User.create! :email => 'ryan@socialcast.com', :password => 'testing'
          params = {
            :format => :json,
            :grant_type => 'password',
            :username => @user.email,
            :password => 'testing'
          }
          auth_header = ActionController::HttpAuthentication::Basic.encode_credentials client.app_identifier, 'invalid secret'
          post '/oauth2/token', params, 'HTTP_AUTHORIZATION' => auth_header
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json'  }
        it 'returns json' do
          expected = {
            :error_description => "invalid client credentials",
            :error => "invalid_client"
          }
          response.body.should match_json(expected)
        end
      end
      context 'with invalid password' do
        with :client
        before do
          @user = User.create! :email => 'ryan@socialcast.com', :password => 'testing'

          params = {
            :format => :json,
            :grant_type => 'password',
            :client_id => client.app_identifier,
            :client_secret => client.secret,
            :username => @user.email,
            :password => 'bar'
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json'  }
        it 'returns json' do
          expected = {
            :error_description => "invalid password authentication request",
            :error => "invalid_grant"
          }
          response.body.should match_json(expected)
        end
      end
      context 'with invalid client_id' do
        with :client
        before do
          @user = User.create! :email => 'ryan@socialcast.com', :password => 'testing'

          params = {
            :format => :json,
            :grant_type => 'password',
            :client_id => 'invalid',
            :client_secret => client.secret,
            :username => @user.email,
            :password => 'testing'
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json'  }
        it 'returns json' do
          expected = {
            :error_description => "invalid client credentials",
            :error => "invalid_client"
          }
          response.body.should match_json(expected)
        end
      end
      context 'with invalid client_secret' do
        with :client
        before do
          @user = User.create! :email => 'ryan@socialcast.com', :password => 'testing'

          params = {
            :format => :json,
            :grant_type => 'password',
            :client_id => client.app_identifier,
            :client_secret => 'invalid',
            :username => @user.email,
            :password => 'testing'
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json'  }
        it 'returns json' do
          expected = {
            :error_description => "invalid client credentials",
            :error => "invalid_client"
          }
          response.body.should match_json(expected)
        end
      end
      context 'with unknow email' do
        with :client
        before do
          params = {
            :grant_type => 'password',
            :client_id => client.app_identifier,
            :client_secret => 'invalid',
            :username => "unknow_email@socialcast.com",
            :password => 'testtest'
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json'  }
        it 'returns json' do
          expected = {
            :error_description => "invalid client credentials",
            :error => "invalid_client"
          }
          response.body.should match_json(expected)
        end
      end
    end
  end
end

