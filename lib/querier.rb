# Class responsible for performing a search for a given item in the market website
class Querier
  def initialize(page: :page_not_set)
    @page = page
  end

  def search_item(item_name)
    item_name = item_name.to_s
    fail ArgumentError if item_name.empty?

    @page = @page.form_with(id: search_form_id) do |whosell|
      fail UnknownPage if whosell.nil?
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
