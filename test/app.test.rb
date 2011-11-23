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
    assert_equal load_average["load_one"], 0.02
    assert_equal load_average["load_five"], 0.05
    assert_equal load_average["load_fifteen"], 0.01
  end

  # memory
  def test_memory
    MemoryService.stubs(:system_output).returns <<-sys_output
             total       used       free     shared    buffers     cached
Mem:       2004104    1887516     116588          0     419368     669652
-/+ buffers/cache:     798496    1205608
Swap:            0          0          0
    sys_output
    get "/memory.json"
    memory_usage = JSON.parse last_response.body
    assert_equal memory_usage["mem_total"], 2004104
    assert_equal memory_usage["mem_used"], 1887516
    assert_equal memory_usage["mem_free"], 116588
    assert_equal memory_usage["mem_shared"], 0
    assert_equal memory_usage["mem_buffers"], 419368
    assert_equal memory_usage["mem_cached"], 669652
    assert_equal memory_usage["mem_used_normalized"], 798496
    assert_equal memory_usage["mem_free_normalized"], 1205608
  end

end
