require 'mechanize'
require_relative './authenticator'
require_relative './querier'
require_relative './results_parser'

module MarketRogue
  module TalonRO
    # The entry point for scraping the market website. It's composite of an Authenticator,
    # a Querier and a ResultsParser.
    # Given the credentials and the item name, it authenticates in the market website, performs
    # a search and parse the results
    class Base
      attr_accessor :username, :password, :item_name, :authenticator,
                    :querier, :results_parser

      WHOSELL_URL = ENV['T_URL']

      def initialize(username:, password:, authenticator: nil, querier: nil, results_parser: nil)
        self.username = username
        self.password = password
        self.authenticator = authenticator || Authenticator.new(
          username: username, password: password, page: Mechanize.new.get(WHOSELL_URL)
        )

        @page = self.authenticator.authenticate!

        self.querier = querier || Querier.new(page: @page)
        self.results_parser = results_parser || ResultsParser.new
      end

      def scrap(item_or_items_names)
        items_names = Array(item_or_items_names)
        items_names.flat_map do |item_name|
          @page = querier.search_item(item_name)
          results = results_parser.read @page
          yield results if block_given?
          results
        end
      end
    end
  end
end
