require_relative './authenticator'
require_relative './querier'
require_relative './results_parser'

module MarketRogue
  class TalonRO
    # The entry point for scraping the market website. It's composite of an Authenticator,
    # a Querier and a ResultsParser.
    # Given the credentials and the item name, it authenticates in the market website, performs
    # a search and parse the results
    attr_reader :username, :password, :agent

    def initialize(username:, password:)
      @agent = Authenticator.new(username: username, password: password).authenticate!
      @querier = Querier.new(agent: @agent)
      @selling_results_parser = SellingResultsParser.new
      @buying_results_parser = BuyingResultsParser.new
    end

    #TODO: recover when the session expires
    def buying_item item_name
      @buying_results_parser.read @querier.buying_item(item_name)
    end

    def selling_item item_name
      @selling_results_parser.read @querier.selling_item(item_name)
    end
  end
end
