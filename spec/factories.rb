FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "Person #{n}"}
    sequence(:email) {|n| "person_#{n}@example.com"}
    password 'complex123'
    password_confirmation 'complex123'

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content 'Loreum ipsum'
    user
  end
end