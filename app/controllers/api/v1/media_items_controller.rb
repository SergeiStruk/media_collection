class Api::V1::MediaItemsController < ApplicationController
  respond_to :json

  def index
    items = MediaItem.search(current_user, params[:search])
    respond_with items
  end
end
