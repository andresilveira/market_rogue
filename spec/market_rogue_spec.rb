require_relative './spec_helper'

require_relative '../lib/market_rogue'

describe MarketRogue do
  let(:market_rogue) { MarketRogue::TalonRO.new username: ENV['T_USERNAME'], password: ENV['T_PASSWORD'] }

  it '#buying_item' do
    market_rogue.selling_item('strawberry')
    skip
  end

  it '#buying_item' do
    skip
  end
end
