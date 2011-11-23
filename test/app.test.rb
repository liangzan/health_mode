require File.expand_path(File.dirname(__FILE__) + '/../app')
require 'test/unit'
require 'rack/test'
require 'mocha'

class BroadcastModeTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # index page
  def test_index
    get "/"
    assert last_response.ok?
  end


  # cpu load
  def test_load
    LoadService.stubs(:system_output).returns(" 11:37:37 up  1:59,  1 user,  load average: 0.02, 0.05, 0.01")
    get "/load.json"
    load_average = JSON.parse last_response.body
    assert_equal load_average["one_minute"], "0.02"
    assert_equal load_average["five_minutes"], "0.05"
    assert_equal load_average["fifteen_minutes"], "0.01"
  end
end
