FactoryGirl.define do
  factory :client, :class => Devise::Oauth2Providable.models.client.to_s do
    sequence(:name) {|n| "test_#{n}" }
    website 'http://localhost'
    redirect_uri 'http://localhost:3000'
  end
end
