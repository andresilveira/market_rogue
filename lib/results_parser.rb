# Class responsible for parsing and structuring the results of a search in the market website
class ResultsParser

  REFINEMENT_NAME_SLOTS_REGEX = /\+*(?<refinement>\d*)(?<item_name>[\s\w\']+)\[*(?<slots>\d*)\]*/

  def read(page)
    scrap_entries(page).map do |entry|
      entry = entry.children.select(&table_cell_elements)
      item_name_hash = entry[0].text.downcase.gsub(/[\n\t\r]/, '').strip.match(REFINEMENT_NAME_SLOTS_REGEX)
      {
        item_name:  item_name_hash[:item_name].strip,
        refinement: item_name_hash[:refinement].to_i,
        slots:      item_name_hash[:slots].to_i,
        cards:      entry[1].children.select(&anchor_elements).map(&dowcase_text),
        price:      entry[2].text.strip.delete('.').to_i,
        amount:     entry[3].text.strip.delete('.').to_i,
        shop_title: entry[4].text.strip,
        vendor:     entry[5].text.strip,
        coords:     entry[6].text.strip
      }
    end
  end

  private

  def table_cell_elements
    proc { |e| e.name == 'td' }
  end

  def anchor_elements
    proc { |e| e.name == 'a' }
  end

  def dowcase_text
    proc { |e| e.text.downcase }
  end

  def scrap_entries(page)
    entries = page.search('#content_wrap > .table_data')
    fail UnknownPageException, "Couldn't find entries table" if entries.empty?

    entries.search('tr:not(.table_row_subtop)').search('tr:not(.table_row_top)')
  end

  class UnknownPageException < Exception
  end
end

class SellingResultsParser < ResultsParser
end

class BuyingResultsParser < ResultsParser
  def read(page)
    scrap_entries(page).map do |entry|
      entry = entry.children.select(&table_cell_elements)
      item_name_hash = entry[0].text.downcase.gsub(/[\n\t\r]/, '').strip.match(REFINEMENT_NAME_SLOTS_REGEX)
      {
        item_name:  item_name_hash[:item_name].strip,
        refinement: item_name_hash[:refinement].to_i,
        slots:      item_name_hash[:slots].to_i,
        price:      entry[1].text.strip.delete('.').to_i,
        amount:     entry[2].text.strip.delete('.').to_i,
        shop_title: entry[3].text.strip,
        vendor:     entry[4].text.strip,
        coords:     entry[5].text.strip
      }
    end
  end
end
