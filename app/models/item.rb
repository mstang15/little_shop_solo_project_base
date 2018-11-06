class Item < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :orders, through: :order_items


  validates_presence_of :name, :description
  validates :price, presence: true, numericality: {
    only_integer: false,
    greater_than_or_equal_to: 0
  }
  validates :inventory, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :slug, uniqueness: true

  after_validation :set_slug

  def to_param
    slug
  end

  def self.popular_items(quantity)
    select('items.*, sum(order_items.quantity) as total_ordered')
      .joins(:orders)
      .where('orders.status != ?', :cancelled)
      .where('order_items.fulfilled = ?', true)
      .group('items.id, order_items.id')
      .order('total_ordered desc')
      .limit(quantity)
  end

  private

  def set_slug
    self.slug = name.to_s.parameterize+(rand(0..100000000).to_s)
  end

end
