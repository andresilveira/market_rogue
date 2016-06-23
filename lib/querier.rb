# Class responsible for performing a search for a given item in the market website
class Querier
  def initialize(page: :page_not_set)
    fail UnknownPage unless page.uri.path == URI.parse(ENV['T_URL']).path

    @page = page
  end

  def search_item(item_name)
    item_name = item_name.to_s
    fail ArgumentError if item_name.empty?

    @page = @page.form_with(id: search_form_id) do |whosell|
      whosell.field_with(name: item_field_name).value = item_name
    end.submit
  end

  private

  def search_form_id
    'validation'
  end

  def item_field_name
    'name'
  end

  class UnknownPage < Exception
  end
end
