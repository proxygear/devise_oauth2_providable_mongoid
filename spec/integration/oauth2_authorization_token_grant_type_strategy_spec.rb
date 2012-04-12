require 'spec_helper'

describe Devise::Strategies::Oauth2AuthorizationCodeGrantTypeStrategy do
  describe 'POST /oauth2/token' do
    describe 'with grant_type=authorization_code' do
      context 'with valid params' do
        with :client
        with :user
        before do
          @authorization_code = user.send(ABSTRACT(:authorization_code_plur)).create(
            ABSTRACT(:client_sym_id) => client,
            :redirect_uri => client.redirect_uri
          )
          params = {
            :grant_type => 'authorization_code',
            :client_id => client.app_identifier,
            :client_secret => client.secret,
            :code => @authorization_code.token
          }
          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 200 }
        it { response.content_type.should == 'application/json' }
        it 'returns json' do
          token = ABSTRACT(:access_token).last
          refresh_token = ABSTRACT(:refresh_token).last
          expected = {
            :token_type => 'bearer',
            :expires_in => 900,
            :refresh_token => refresh_token.token,
            :access_token => token.token
          }
          response.body.should match_json(expected)
        end
      end
      context 'with expired authorization_code' do
        with :client
        with :user
        before do
          expired_date = 2.days.ago
          
          code_class = user.send ABSTRACT(:authorization_code_plur)
          @authorization_code = code_class.new(
            ABSTRACT(:client_sym_id) => client,
            :redirect_uri => client.redirect_uri,
            :expires_at => expired_date
          )
          @authorization_code.save!
          @authorization_code.expires_at = expired_date
          @authorization_code.save!
          
          params = {
            :grant_type => 'authorization_code',
            :client_id => client.app_identifier,
            :client_secret => client.secret,
            :code => @authorization_code.token
          }

          post '/oauth2/token', params
        end
        
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json' }
        it 'returns json' do
          puts "@authorization_code #{@authorization_code.inspect}"
          puts "Class : #{ABSTRACT(:authorization_code).not_expired.inspect}"
          expected = {
            :error => 'invalid_grant',
            :error_description => 'invalid authorization code request'
          }
          response.body.should match_json(expected)
        end
        
        it "not figure in data base (because expired)" do # default scope issue
          @authorization_code.reload.expires_at.should < Time.now.utc
          assert_equal 0, ABSTRACT(:authorization_code).not_expired.count
          model = ABSTRACT(:authorization_code)
          if code = model.of_client(client.id).not_expired.find_by_token(@authorization_code.token)
            raise "dead"
          end
          assert_equal 1, ABSTRACT(:authorization_code).count
        end
      end
      context 'with invalid authorization_code' do
        with :client
        with :user
        before do
          @authorization_code = user.send(ABSTRACT(:authorization_code_plur)).create(
            ABSTRACT(:client_sym_id) => client,
            :redirect_uri => client.redirect_uri
          )
          params = {
            :grant_type => 'authorization_code',
            :client_id => client.app_identifier,
            :client_secret => client.secret,
            :code => 'invalid'
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json' }
        it 'returns json' do
          expected = {
            :error => 'invalid_grant',
            :error_description => 'invalid authorization code request'
          }
          response.body.should match_json(expected)
        end
      end
      context 'with invalid client_secret' do
        with :user
        with :client
        before do
          @authorization_code = user.send(ABSTRACT(:authorization_code_plur)).create(
            ABSTRACT(:client_sym_id) => client,
            :redirect_uri => client.redirect_uri
          )
          params = {
            :grant_type => 'authorization_code',
            :client_id => client.app_identifier,
            :client_secret => 'invalid',
            :code => @authorization_code.token
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json' }
        it 'returns json' do
          expected = {
            :error => 'invalid_client',
            :error_description => 'invalid client credentials'
          }
          response.body.should match_json(expected)
        end
      end
      context 'with invalid client_id' do
        with :user
        with :client
        before do
          @authorization_code = user.send(ABSTRACT(:authorization_code_plur)).create(
            ABSTRACT(:client_sym_id) => client,
            :redirect_uri => client.redirect_uri
          )
          params = {
            :grant_type => :authorization_code,
            :client_id => 'invalid',
            :client_sym_secret => client.secret,
            :code => @authorization_code.token
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json' }
        it 'returns json' do
          expected = {
            :error => 'invalid_client',
            :error_description => 'invalid client credentials'
          }
          response.body.should match_json(expected)
        end
      end
    end
  end
end

