FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "email_#{n}@devise_oauth2_providable.com" }
    password 'testing'
  end
end
