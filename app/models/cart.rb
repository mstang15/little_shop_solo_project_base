class Cart
  attr_reader :contents

  def initialize(initial_contents)
    @contents = initial_contents || Hash.new(0)
  end

  def total_count
    @contents.values.sum
  end

  def add_item(item_id)
    @contents[item_id.to_s] ||= 0
    @contents[item_id.to_s] += 1
  end

  def count_of(item_id)
    @contents[item_id.to_s].to_i
  end

  def grand_total
    total = 0
    Item.where(id: @contents.keys).each do |item|
      total += (item.price * count_of(item.id))
    end
    total
  end
end
