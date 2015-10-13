FactoryGirl.define do
  factory :media_item do
    user
    name 'Media Item'
    url 'http://example.com'
    media_type 'Website'

    trait :public do
      is_private false
    end
  end
end
