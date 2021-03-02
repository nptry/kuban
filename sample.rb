class Sample
  require './Contract'
  require './RentingPhase'
  require './Invoice'
  require './LineItem'
  require './Utils'

  # print
  # 创建合同
  contract = Contract.new(starts: '2020-11-16', ends: '2021-03-16', monthly_rent: 500000, billing_cycle: 3)
  # 生成交租阶段
  renting_phases = contract.generate_renting_phases
  invoices, line_items = [], []
  renting_phases.each do |renting_phase|
    # 创建账单
    invoice = renting_phase.generate_invoice
    invoices << invoice
    # 创建账单明细
    line_items += invoice.generate_line_items
  end

  puts "contract:"
  puts contract.instance_variables.map { |v| "#{v}: #{contract.instance_variable_get(v)}"}.join(', ')
  puts "renting_phases:"
  renting_phases.each do |rent_phase|
    puts rent_phase.instance_variables.map { |v| "#{v}: #{rent_phase.instance_variable_get(v)}"}.join(', ')
  end
  puts "invoices:"
  invoices.each do |invoice|
    puts invoice.instance_variables.map { |v| "#{v}: #{invoice.instance_variable_get(v)}"}.join(', ')
  end
  puts "line_items:"
  line_items.each do |line_item|
    puts line_item.instance_variables.map { |v| "#{v}: #{line_item.instance_variable_get(v)}"}.join(', ')
  end
end
