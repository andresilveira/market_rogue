# Class responsible for parsing and structuring the results of a search in the market website
class ResultsParser
  def read(page)
    scrap_entries(page).map do |entry|
      entry = entry.children.select { |child| child.name == 'td' }
      {
        name:   entry[0].text.strip.downcase,
        cards:  '', # entry[1].text.strip.downcase,
        price:  entry[2].text.strip.delete('.').to_i,
        amount: entry[3].text.strip.delete('.').to_i,
        title:  entry[4].text.strip,
        vendor: entry[5].text.strip
      }
    end
  end

  private

  def scrap_entries(page)
    entries = page.search('#content_wrap > .table_data')
    fail UnknownPageException, "Couldn't find entries table" if entries.empty?

    entries.search('tr:not(.table_row_subtop)').search('tr:not(.table_row_top)')
  end

  class UnknownPageException < Exception
  end
end
