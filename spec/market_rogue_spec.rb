require_relative './spec_helper'

require_relative '../lib/market_rogue'

describe MarketRogue do
  let(:subject) { MarketRogue::TalonRO }

  it 'must have a username' do
    proc { subject.new password: 'pass' }.must_raise ArgumentError
  end

  it 'must have a password' do
    proc { subject.new username: 'user' }.must_raise ArgumentError
  end

  describe '#scrap' do
    before do
      @authenticated_scraper = subject.new username: ENV['T_USERNAME'], password: ENV['T_PASSWORD']
    end

    it 'should receive an item name' do
      proc { @authenticated_scraper.scrap }.must_raise ArgumentError
    end

    it 'should call search_item on its querier' do
      item_name = 'item_name'
      mock_querier = Minitest::Mock.new.expect(:search_item, true, [item_name])
      @authenticated_scraper.querier = mock_querier

      @authenticated_scraper.results_parser.stub :read, true do
        @authenticated_scraper.scrap(item_name)
      end
      mock_querier.verify
    end

    it 'should call read on its results_parser' do
      mock_results_parser = Minitest::Mock.new.expect(:read, true, [Mechanize::Page])
      @authenticated_scraper.results_parser = mock_results_parser
      @authenticated_scraper.scrap('item_name')
      mock_results_parser.verify
    end

    describe 'when receiving a list with n items' do
      it 'must call a block for each item' do
        block_called = 0
        @authenticated_scraper.scrap(%w(item_name item_name)) { block_called += 1 }
        block_called.must_equal 2
      end
    end
  end
end
