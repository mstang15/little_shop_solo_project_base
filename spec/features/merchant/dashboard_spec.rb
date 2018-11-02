require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'as a merchant' do
    before(:each) do
      @user = create(:user)
      @merchant = create(:merchant)
      @item_1, @item_2, @item_3, @item_4, @item_5 = create_list(:item, 5, user: @merchant)
      @item_6 = create(:item, user:@merchant, image: "https://images.pexels.com/photos/204611/pexels-photo-204611.jpeg?cs=srgb&dl=brand-business-cellphone-204611.jpg&fm=jpg")

      @order_1 = create(:order, user: @user)
      create(:order_item, order: @order_1, item: @item_1)
      create(:order_item, order: @order_1, item: @item_2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    end

    it 'has a to do list' do
      visit dashboard_path

      expect(page).to have_content("To Do:")
    end

    it 'has links to their items with stock images' do
      visit dashboard_path

      expect(page).to have_link("#{@item_1.name}")
      expect(page).to have_link("#{@item_2.name}")
      expect(page).to have_link("#{@item_3.name}")
      expect(page).to have_link("#{@item_4.name}")
      expect(page).to have_link("#{@item_5.name}")
    end

    it 'items without stock images dont appear in todo list' do
      visit dashboard_path

      expect(page).to_not have_link("#{@item_6.name}")
    end

    it 'links go to edit image page' do
      visit dashboard_path

      click_link("#{@item_1.name}")

      expect(current_path).to eq(edit_merchant_item_path(@merchant,@item_1))
    end

    it 'I can see how many items are not fulfilled and how much revenue is missed' do
      visit dashboard_path
      
      price = @item_1.price + @item_2.price

      expect(page).to have_content("You have 2 unfulfilled orders worth $#{price}0")
    end
  end
end
