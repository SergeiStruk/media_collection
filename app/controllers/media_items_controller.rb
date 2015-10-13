class MediaItemsController < ApplicationController
  before_action :authenticate_user!, except: :index

  respond_to :html

  def index
    @media_items = MediaItem.search(current_user, params[:search])
  end

  def new
    @media_item = current_user.media_items.build
  end

  def create
    @media_item = current_user.media_items.create(media_item_params)
    respond_with @media_item, location: media_items_path
  end

  def destroy
    @media_item = current_user.media_items.find(params[:id])
    @media_item.destroy
    respond_with @media_item, location: media_items_path
  end

  private

  def media_item_params
    params.require(:media_item).permit(:name, :url, :media_type, :is_private)
  end
end
