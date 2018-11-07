class Admin::ItemsController < ApplicationController
  before_action :require_admin

  def edit
    @item = Item.find_by(slug: params[:slug])
  end

  def update
    @item = Item.find_by(slug: params[:slug])
    @item.update(item_params)
      flash[:success] = "Item updated"
      redirect_to item_path(@item)
  end


  private

  def item_params
    params.require(:item).permit(:user_id, :name, :description, :image, :price, :inventory, :slug)
  end

  def require_admin
    if !current_admin?
      render file: "/app/views/errors/not_found"
    end
  end

end
