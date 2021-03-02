require './RentingPhase'
require './Utils'

class Contract
  attr_accessor :starts, :ends, :amount, :monthly_rent, :billing_cycle
  def initialize(starts:, ends:, monthly_rent:, billing_cycle:)
    @starts = starts.to_date
    @ends = ends.to_date
    @monthly_rent = monthly_rent
    @billing_cycle = billing_cycle
    @amount = Utils.contract_amount(starts: @starts, ends: @ends, monthly_rent: monthly_rent)
  end

  def generate_renting_phases
    phases = Utils.generate_range_params(starts: starts, ends: ends, monthly_rent: monthly_rent, billing_cycle: billing_cycle)
    renting_phases = []
    phases.each do |phase|
      renting_phase = RentingPhase.new(starts: phase[:phase_starts], ends: phase[:phase_ends], rent_date: phase[:rent_date], phase_amount: phase[:phase_amount], contract: self)
      renting_phases << renting_phase
    end
    renting_phases
  end

end


