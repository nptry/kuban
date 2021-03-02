class RentingPhase
  attr_accessor :starts, :ends, :rent_date, :phase_amount, :invoice_state, :contract
  def initialize(starts:, ends:, rent_date:, phase_amount:, contract:)
    @starts = starts
    @ends = ends
    @rent_date = rent_date
    @phase_amount = phase_amount
    @contract = contract
  end

  def generate_invoice
    Invoice.new(starts: starts, ends: ends, rent_date: rent_date, amount: phase_amount, renting_phase: self)
  end

  class << self
    # 每日定时任务
    def generate_invoice_schedule
      RentingPhase.where(invoice_state: false).where(rent_date: Date.today + 3.days).each do |rent_phase|
        Invoice.generate_invoice(rent_phase)
        rent_phase.invoice_state = true
      end
    end
  end
end
