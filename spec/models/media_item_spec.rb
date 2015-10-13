require 'rails_helper'

describe MediaItem do
  let(:user){ create(:user) }

  describe 'validations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:media_type) }
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

  describe '.for_user' do
    let!(:item1) { create(:media_item, :public) }
    let!(:item2) { create(:media_item) }
    let!(:item3) { create(:media_item, user: user) }
    let!(:item4) { create(:media_item, :public, user: user) }
    let!(:item5) { create(:media_item, user: user) }

    it "should sort items by user and privacity" do
      items = MediaItem.for_user(user).pluck(:id)
      expect(items).to eq [item3.id, item5.id, item4.id, item1.id]
    end
  end

  describe '.search' do
    it "should invoke for_user method if user presents" do
      expect(MediaItem).to receive(:for_user).with(user)
      MediaItem.search(user, nil)
    end

    it "should not invoke for_user method if user is nil" do
      expect(MediaItem).to receive(:for_user).never
      MediaItem.search(nil, nil)
    end
  end
end
