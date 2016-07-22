require_relative 'spec_helper'

require_relative '../lib/authenticator.rb'

require 'mechanize'

describe Authenticator do
  it 'must have a username' do
    proc { Authenticator.new username: nil, password: 'something' }.must_raise ArgumentError
  end

  it 'must have a password' do
    proc { Authenticator.new username: 'something', password: '' }.must_raise ArgumentError
  end

  describe '.authenticate!' do
    let(:valid_credentials) { { username: ENV['T_USERNAME'], password: ENV['T_PASSWORD'] } }
    let(:invalid_credentials) { { username: 'lololololo', password: 'lolololololo' } }

    it 'should return a agent authenticated when successful' do
      authenticated_agent = Authenticator.new(valid_credentials).authenticate!  
      authenticated_agent.form_with(Authenticator::LOGIN_ACTION).must_be_nil
    end

    it 'should raise an exception when failed' do
      proc { Authenticator.new(invalid_credentials).authenticate! }.must_raise Authenticator::InvalidUserException
    end
  end
end
