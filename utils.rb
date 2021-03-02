require "active_support/all"

class Utils

  class << self
    def contract_amount(starts: ,ends: ,monthly_rent:)
      amount_of_range(starts, ends, monthly_rent)
    end
    #生成交租阶段信息
    def generate_range_params(starts:, ends:, monthly_rent:, billing_cycle:)
      result = []
      months = (starts.beginning_of_month..ends.beginning_of_month).select {|d| d.day == 1}
      months.each_slice(billing_cycle).with_index do |range, index|
        phase_starts = index == 0 ? starts : range[0]
        phase_ends = (index + 1) * billing_cycle >= months.count ? ends : range[-1].end_of_month
        rent_date = index == 0 ? phase_starts : (phase_starts - 1.month).change(day: 15)
        rent_date = starts if rent_date < starts
        phase_amount = amount_of_range(phase_starts, phase_ends, monthly_rent)
        result << {phase_starts: phase_starts, phase_ends: phase_ends, rent_date: rent_date, phase_amount: phase_amount}
      end
      result
    end

    def amount_of_range(starts, ends, monthly_rent)
      months = (starts.beginning_of_month..ends.beginning_of_month).select {|d| d.day == 1}
      if months.count > 1
        first_month_amount(starts, ends, monthly_rent) + last_month_amount(starts, ends, monthly_rent) + (months.count - 2) * monthly_rent
      else
        first_month_amount(starts, ends, monthly_rent)
      end
    end

    def first_month_amount(starts, ends, monthly_rent)
      if starts == starts.beginning_of_month && ends >= starts.end_of_month
        monthly_rent
      else
        ((starts..[starts.end_of_month, ends].min).count * (monthly_rent * 12 / 365.0)).round
      end
    end
    def last_month_amount(starts, ends, monthly_rent)
      if starts <= ends.beginning_of_month && ends == ends.end_of_month
        monthly_rent
      else
        ((ends.beginning_of_month..ends).count * (monthly_rent * 12 / 365.0)).round
      end
    end

    #生成账单明细信息
    def generate_item_params(starts:, ends:, monthly_rent:)
      result = []
      months = (starts.beginning_of_month..ends.beginning_of_month).select {|d| d.day == 1}
      months.each_with_index do |month, index|
        item_starts = index == 0 ? starts : month.beginning_of_month
        item_ends = index + 1 == months.count ? ends : [month.end_of_month, ends].min
        if index == 0 && starts != starts.beginning_of_month
          count_type = 'day'
          unit_price = (monthly_rent * 12 / 365.0).round
          quantity = (starts..month.end_of_month).count
        elsif index + 1 == months.count && ends != ends.end_of_month
          count_type = 'day'
          unit_price = (monthly_rent * 12 / 365.0).round
          quantity = (month.beginning_of_month..ends).count
        else
          count_type = 'month'
          unit_price = monthly_rent
          quantity = 1
        end
        amount = amount_of_range(item_starts, item_ends, monthly_rent)
        result << {starts: item_starts, ends: item_ends, count_type: count_type, quantity: quantity, unit_price: unit_price, amount: amount}
      end
      result
    end
  end

end