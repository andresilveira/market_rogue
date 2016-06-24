require_relative './spec_helper'

require_relative '../lib/market_rogue'
require_relative '../lib/querier'
require_relative '../lib/authenticator'

require 'mechanize'

describe Querier do
  let(:subject) { Querier }

  describe '#search_item' do
    it 'needs a knwon page' do
      skip('needs refactoring to assert the presence of the search form in a method')
      # mock_page = Minitest::Mock.new.expect(:form_with, nil, [{ id: 'validation' }])
      # proc { subject.new(page: mock_page).search_item('mock item') }.must_raise subject::UnknownPage
    end

    it 'returns a page with the results' do
      authenticated_page = Authenticator.new(
        username: ENV['T_USERNAME'],
        password: ENV['T_PASSWORD'],
        page: Mechanize.new.get(MarketRogue::TalonRO::WHOSELL_URL)
      ).authenticate!
      querier = subject.new(page: authenticated_page)
      results_page = querier.search_item 'jellopy'

      results_page.search('#content_wrap > h3').text.downcase.must_include 'search results'
    end
  end
end
