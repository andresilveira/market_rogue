# market_rogue [![Build Status](https://semaphoreci.com/api/v1/andresilveirah/market_rogue/branches/master/shields_badge.svg)](https://semaphoreci.com/andresilveirah/market_rogue)

It's a gem that transforms different [Ragnarok](https://en.wikipedia.org/wiki/Ragnarok_Online) servers websites into APIs.

Currently the only server implemented is [TalonROs](https://talonro.com/). But I'm planning to add more depending on the demand.

## Usage

```ruby
market_agent = MarketRogue::TalonRO.new(username: 'username', password: 'nice_password')
# => ... authenticated market_agent
market_agent.buying_item('strawberry')
# => [
#  { 
#    item_name: "strawberry",
#    refinement: 0,
#    slots: 0,
#    cards: [],
#    price: 3_000,
#    amount: 8,
#    shop_title: 'Strawberries for all',
#    vendor: 'A nice vendor',
#    coords: '75,109'
#  }
#]
```
`MarketRogue::*` should always respond to two methods: `buying_item` and `selling_item`. And those always return an array of hashes, as illustrated the above.

### Tips and tricks
1. The authentication is made by the time the `MarketRogue::TalonRO` is initialized, therefore it take some time for the http requests, etc.
2. By the time, the session handling is not really robust. It means, if the agent's session expires an exception will be thrown and the only solution (for now) is to instantiate the object again.


## TODO
* Fix the two items from `Tips and tricks`
* Add other servers
