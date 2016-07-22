# Class responsible for performing a search for a given item in the market website
class Querier

  WHOSELL_FORM_ACTION = { action: /whosell/ }
  WHOBUY_FORM_ACTION  = { action: /whobuy/  }
  WHOSELL_LINK_HREF   = { href:   /whosell/ }
  WHOBUY_LINK_HREF    = { href:   /whobuy/  }
  ITEM_FIELD_NAME     = { name:   "name"    }

  def initialize(agent: :agent_not_set)
    @agent = agent
  end

  def buying_item(item_name)
    @agent = @agent.link_with(WHOBUY_LINK_HREF).click
    @agent = search_item(item_name, WHOBUY_FORM_ACTION)
  end
  
  def selling_item(item_name)
    @agent = @agent.link_with(WHOSELL_LINK_HREF).click
    @agent = search_item(item_name, WHOSELL_FORM_ACTION)
    @agent
  end

  private

  def search_item(item_name, form_name)
    @agent = @agent.form_with(form_name) do |f|
      fail UnknownPage.new('Search form not found.') if f.nil?

      f.field_with(ITEM_FIELD_NAME).value = item_name
    end.submit
  end

  class UnknownPage < Exception
  end
end
