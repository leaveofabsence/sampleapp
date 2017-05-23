FactoryGirl.define do
  factory :user do
    name 'Joe Horton'
    email 'joe@horton.com'
    password 'complex123'
    password_confirmation 'complex123'
  end
end