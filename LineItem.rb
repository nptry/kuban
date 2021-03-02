class LineItem
  attr_accessor :starts, :ends, :count_type, :quantity, :unit_price, :amount, :invoice
  def initialize(starts:, ends:, count_type:, quantity:, unit_price:, amount:, invoice: )
    @starts = starts
    @ends = ends
    @count_type = count_type
    @quantity = quantity
    @unit_price = unit_price
    @amount = amount
    @invoice = invoice
  end

end