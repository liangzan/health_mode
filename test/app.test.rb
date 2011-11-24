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
    LoadMetric.stubs(:get_system_metrics).returns("0.18 0.14 0.10 1/419 6130")
    get "/load.json"
    load_average = JSON.parse last_response.body
    assert_equal load_average["load_one"], 0.18
    assert_equal load_average["load_five"], 0.14
    assert_equal load_average["load_fifteen"], 0.10
  end

  # memory
  def test_memory
    MemoryMetric.stubs(:get_system_metrics).returns <<-sys_output
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

  # swap usage
  def test_swap
    SwapMetric.stubs(:system_output).returns <<-sys_output
             total       used       free     shared    buffers     cached
Mem:       2004104    1887516     116588          0     419368     669652
-/+ buffers/cache:     798496    1205608
Swap:            0          0          0
    sys_output
    get "/swap.json"
    swap_usage = JSON.parse last_response.body
    assert_equal swap_usage["swap_total"], 0
    assert_equal swap_usage["swap_used"], 0
    assert_equal swap_usage["swap_free"], 0
  end

  # disk space
  def test_disk_usage
    DiskMetric.stubs(:get_system_metrics).returns <<-sys_output
Filesystem         1024-blocks      Used Available Capacity Mounted on
/dev/sda2             19222656  15440068   2806052      85% /
none                    995424       728    994696       1% /dev
none                   1002052      1096   1000956       1% /dev/shm
none                   1002052       132   1001920       1% /var/run
none                   1002052         0   1002052       0% /var/lock
/dev/sda4            198071540  80614372 107395652      43% /home
total                221295776  96056396 114201328      46%
    sys_output
    get "/disk.json"
    disk_usage = JSON.parse last_response.body
    assert_equal disk_usage["disk_total"], 221295776
    assert_equal disk_usage["disk_used"], 96056396
    assert_equal disk_usage["disk_free"], 114201328
    assert_equal disk_usage["disk_percentage_capacity"], 46
  end


end
