# Class responsible to authenticate in the market website.
class Authenticator
  def initialize(username:, password:, page:)
    fail ArgumentError if username.to_s.empty? || password.to_s.empty? || page.nil?

    @username = username
    @password = password
    @page = page
  end

  def authenticate!
    # TODO: improve error message when the form is not found
    @page = @page.form_with(id: authentication_form_id) do |form|
      form.field_with(name: username_field_name).value = @username
      form.field_with(name: password_field_name).value = @password
    end.submit

    assert_authenticated
  end

  private

  def assert_authenticated
    fail InvalidUserException if @page.uri.path.include? 'login'
    @page
  end

  def authentication_form_id
    'validation'
  end

  def username_field_name
    'auth'
  end

  def password_field_name
    'password'
  end

  class InvalidUserException < Exception
  end
end
