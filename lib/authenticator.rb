require 'mechanize'

# Class responsible to authenticate in the market website.
class Authenticator
  
  URL = 'https://panel.talonro.com/'
  LOGIN_ACTION = { action: /login/ }
  USER_FIELD_NAME = { name: 'auth' }
  PASSWORD_FIELD_NAME = { name: 'password' }

  attr_reader :agent

  def initialize(username:, password:)
    assert_credentials_given(username, password)

    @username = username
    @password = password
    @agent = Mechanize.new.get(URL)
  end

  def authenticate!
    # TODO: improve error message when the form is not found
    @agent = agent.form_with(LOGIN_ACTION) do |f|
      f.field_with(USER_FIELD_NAME).value = @username
      f.field_with(PASSWORD_FIELD_NAME).value = @password
    end.submit

    assert_authenticated
    agent
  end

  private

  def assert_credentials_given(username, password)
    fail ArgumentError.new('Username is missing.') if username.to_s.empty?
    fail ArgumentError.new('Password is missing.') if password.to_s.empty?
  end

  def assert_authenticated
    fail InvalidUserException if @agent.uri.path.include? 'login'
  end

  class InvalidUserException < Exception
  end
end
