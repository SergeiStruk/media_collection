require 'rails_helper'

describe MediaItem do
  describe 'validations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:media_type) }
    it { is_expected.to validate_presence_of(:is_private).in_array([true, false]) }
    it { is_expected.to validate_inclusion_of(:media_type).in_array(MediaItem::TYPES) }
    it { is_expected.to validate_presence_of(:user) }

    it 'should generate error if url is invalid' do
      item = MediaItem.create(url: 'fake')
      expect(item.errors[:url]).to be_include("is invalid.")
    end

    it 'should not generate error if url is valid' do
      item = MediaItem.create(url: 'http://example.com')
      expect(item.errors[:url]).to be_empty
    end
  end
end
