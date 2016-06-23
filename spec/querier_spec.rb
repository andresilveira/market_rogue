require_relative './spec_helper'

require_relative '../lib/querier'
require_relative '../lib/authenticator'

require 'mechanize'

describe Querier do
  let(:subject) { Querier }

  it 'needs a knwon page' do
    proc { subject.new page: Minitest::Mock.new.expect(:uri, URI.parse('')) }.must_raise subject::UnknownPage
  end

  describe '#search_item' do
    it 'returns a page with the results' do
      authenticated_page = Authenticator.new(
        username: ENV['T_USERNAME'],
        password: ENV['T_PASSWORD'],
        page: Mechanize.new.get(ENV['T_URL'])
      ).authenticate!
      querier = subject.new(page: authenticated_page)
      results_page = querier.search_item 'jellopy'

      results_page.search('#content_wrap > h3').text.downcase.must_include 'search results'
    end
  end
end
