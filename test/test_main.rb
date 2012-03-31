begin 
  # try to use require_relative first
  # this only works for 1.9
  require_relative '../main.rb'
rescue NameError
  # oops, must be using 1.8
  # no problem, this will load it then
  require File.expand_path('../main.rb', __FILE__)
end

require 'test/unit'
require 'rack/test'

class MyAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  
  def test_my_default
    get '/'
    assert last_response.ok?
    assert_equal 'Welcome to my page!', last_response.body
  end

  def test_with_params
    post '/', :miles => 333.4, :gallons => 17.355
    assert_equal 200
  end
end