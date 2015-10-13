require "rails_helper"

describe Api::V1::MediaItemsController, type: :controller do
  describe '#index' do
    it 'returns the correct status', type: :controller do
      get :index, format: :json
      expect(response.status).to eql(200)
    end

    it 'returns the correct status', type: :controller do
      create :media_item
      public_item = create :media_item, :public
      get :index, format: :json
      expect(response.body).to eq [public_item].to_json
    end
  end
end
