require_relative './spec_helper'

require_relative '../lib/querier'
require_relative '../lib/authenticator'

require 'mechanize'

describe Querier do
  describe '#search_item' do
    let(:agent) { Authenticator.new(username: ENV['T_USERNAME'], password: ENV['T_PASSWORD']).authenticate! }

    it 'needs a knwon agent' do
      skip('needs refactoring to assert the presence of the search form in a method')
    end

    it 'returns an agent with the results' do
      querier = Querier.new(agent: agent)
      results_agent = querier.buying_item 'jellopy'

      results_agent.search('#content_wrap > h3').text.downcase.must_include 'search results'
    end
  end
end
