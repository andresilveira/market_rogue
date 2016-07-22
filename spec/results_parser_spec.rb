require_relative 'spec_helper'

require 'nokogiri'

require_relative '../lib/results_parser'

describe ResultsParser do
  describe '#read' do
    describe 'when the page has results' do
      it 'return an of hashes for each result' do
        body = <<-HTML
          <div id="content_wrap">
            <h3>Search Results for "unknown item"</h3>
            <table class="table_data table_narrow">
              <tbody>
                <tr class="table_row_top">
                  <td colspan="7"><strong>Prontera</strong></td>
                </tr>
                <tr class="table_row_subtop">
                  <td><strong>Name</strong></td>
                  <td><strong>Cards</strong></td>
                  <td><strong>Price</strong></td>
                  <td><strong>Amt.</strong></td>
                  <td><strong>Title</strong></td>
                  <td><strong>Vendor</strong></td>
                  <td><strong>Coords</strong></td>
                </tr>
               <tr>
                  <td><a class="imgtooltip" target="blank_">Jellopy </a></td>
                  <td> </td>
                  <td>480</td>
                  <td>1420</td>
                  <td>ELU SQI ETC</td>
                  <td>chinitaa</td>
                  <td><a>147,72</a></td>
                </tr>
                <tr class="table_row_top">
                  <td colspan="7"><strong>Pron_mall</strong></td>
                </tr>
                <tr class="table_row_subtop">
                  <td><strong>Name</strong></td>
                  <td><strong>Cards</strong></td>
                  <td><strong>Price</strong></td>
                  <td><strong>Amt.</strong></td>
                  <td><strong>Title</strong></td>
                  <td><strong>Vendor</strong></td>
                  <td><strong>Coords</strong></td>
                </tr>
                <tr>
                  <td><a>Roguemaster's Bow</a></td>
                  <td> </td>
                  <td>3.000</td>
                  <td>8</td>
                  <td>ELU IRON SQI ETC</td>
                  <td>Chancesmith</td>
                  <td><a>75,109</a></td>
                </tr>
                <tr>
      					<td>
                  +4<a>Artemis Bow[3]</a>
                </td>
      					<td>
      						<a>Turtle General Card</a>
                  <br>
                  <a>Turtle General Card</a>
                  <br>
                  <a>Turtle General Card</a>
                  <br>
                </td>
      					<td>280.000.000</td>
      					<td>1</td>
      					<td>Pro Gears Auction House</td>
      					<td>Flavyo</td>
      					<td><a>175,145</a></td>
      				</tr>
              </tbody>
            </table>
          </div>
        HTML
        page = Nokogiri::HTML body
        results = ResultsParser.new.read(page)
        results.must_equal [
          Hash[item_name: 'jellopy',
               refinement: 0,
               slots: 0,
               cards: [],
               price: 480,
               amount: 1420,
               shop_title: 'ELU SQI ETC',
               vendor: 'chinitaa',
               coords: '147,72'],
          Hash[item_name: "roguemaster's bow",
               refinement: 0,
               slots: 0,
               cards: [],
               price: 3_000,
               amount: 8,
               shop_title: 'ELU IRON SQI ETC',
               vendor: 'Chancesmith',
               coords: '75,109'],
           Hash[item_name: 'artemis bow',
                refinement: 4,
                slots: 3,
                cards: ['turtle general card','turtle general card','turtle general card'],
                price: 280000000,
                amount: 1,
                shop_title: 'Pro Gears Auction House',
                vendor: 'Flavyo',
                coords: '175,145']
        ]
      end
    end

    describe 'when the page has no results' do
      it 'returns an empty array' do
        body = <<-HTML
          <div id="content_wrap">
            <h3>Search Results for "unknown item"</h3>
            <table class="table_data table_narrow"></table>
          </div>
        HTML
        page = Nokogiri::HTML body
        results = ResultsParser.new.read(page)
        results.must_be_empty
      end
    end

    describe 'when the page is different then expected' do
      it 'raises UnknownPageException' do
        page = Nokogiri::HTML ''
        proc { ResultsParser.new.read(page) }.must_raise ResultsParser::UnknownPageException
      end
    end
  end
end

describe BuyingResultsParser do
  describe '#read' do
    describe 'when the page has results' do
      it 'return an of hashes for each result' do
        body = <<-HTML
          <div id="content_wrap">
            <h3>Search Results for "unknown item"</h3>
            <table class="table_data table_narrow">
              <tbody>
                <tr class="table_row_top">
                  <td colspan="7"><strong>Prontera</strong></td>
                </tr>
                <tr class="table_row_subtop">
                  <td><strong>Name</strong></td>
                  <td><strong>Price</strong></td>
                  <td><strong>Amt.</strong></td>
                  <td><strong>Title</strong></td>
                  <td><strong>Vendor</strong></td>
                  <td><strong>Coords</strong></td>
                </tr>
               <tr>
                  <td><a class="imgtooltip" target="blank_">Jellopy </a></td>
                  <td>480</td>
                  <td>1420</td>
                  <td>ELU SQI ETC</td>
                  <td>chinitaa</td>
                  <td><a>147,72</a></td>
               </tr>
              </tbody>
            </table>
          </div>
        HTML
        page = Nokogiri::HTML body
        results = BuyingResultsParser.new.read(page)
        results.must_equal [
          { 
            item_name: 'jellopy',
            refinement: 0,
            slots: 0,
            price: 480,
            amount: 1420,
            shop_title: 'ELU SQI ETC',
            vendor: 'chinitaa',
            coords: '147,72'
          }
        ]
      end
    end

    describe 'when the page is different then expected' do
      it 'raises UnknownPageException' do
        page = Nokogiri::HTML ''
        proc { ResultsParser.new.read(page) }.must_raise ResultsParser::UnknownPageException
      end
    end
  end
end
