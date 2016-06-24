require_relative 'spec_helper'

require_relative '../lib/market_rogue'
require_relative '../lib/authenticator.rb'

require 'mechanize'

describe Authenticator do
  let(:subject) { Authenticator }

  it 'must have a username' do
    proc { subject.new username: nil, password: 'something' }.must_raise ArgumentError
  end

  it 'must have a password' do
    proc { subject.new username: 'something', password: '' }.must_raise ArgumentError
  end

  it 'must have a page to authenticate to' do
    proc { subject.new username: 'something', password: '' }.must_raise ArgumentError
  end

  describe '.authenticate!' do
    before do
      @page_to_authenticate = { page: Mechanize.new.get(MarketRogue::TalonRO::WHOSELL_URL) }
      @valid_user = { username: ENV['T_USERNAME'], password: ENV['T_PASSWORD'] }
      @invalid_user = { username: 'lololololo', password: 'lolololololo' }
    end

    it 'should return a page authenticated when successful' do
      page = subject.new(@page_to_authenticate.merge(@valid_user)).authenticate!
      page.uri.path.wont_include 'login'
    end

    it 'should raise an exception when failed' do
      proc { subject.new(@page_to_authenticate.merge(@invalid_user)).authenticate! }.must_raise subject::InvalidUserException
    end
  end
end
