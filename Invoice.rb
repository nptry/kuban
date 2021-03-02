require './LineItem'
require './Utils'
class Invoice
  attr_accessor :starts, :ends, :rent_date, :amount, :renting_phase
  def initialize(starts:, ends:, rent_date:, amount:, renting_phase:)
    @starts = starts
    @ends = ends
    @rent_date = rent_date
    @phase_amount = amount
    @renting_phase = renting_phase
  end

  def generate_line_items
    items = Utils.generate_item_params(starts: starts, ends: ends, monthly_rent: renting_phase.contract.monthly_rent)
    line_items = []
    items.each do |item|
      line_item = LineItem.new(starts: item[:starts], ends: item[:ends], count_type: item[:count_type],
                   quantity: item[:quantity], unit_price: item[:unit_price], amount: item[:amount], invoice: self)
      line_items << line_item
    end
    line_items
  end

end