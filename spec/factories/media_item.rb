FactoryGirl.define do
  factory :media_item do
    user
    name 'Media Item'
    url 'http://example.com'
    media_type 'Website'
  end
end
