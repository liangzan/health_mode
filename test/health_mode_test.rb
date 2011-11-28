require File.expand_path(File.dirname(__FILE__) + '/../lib/health_mode')
require 'test/unit'
require 'rack/test'
require 'mocha'

class HealthModeTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    HealthMode::Agent.new
  end

  def test_index
    get "/"
    assert last_response.ok?
  end

  def test_load
    HealthMode::LoadMetric.stubs(:get_system_metrics).returns("0.18 0.14 0.10 1/419 6130")
    get "/load.json"
    load_average = JSON.parse last_response.body
    assert_equal load_average["load_one"], 0.18
    assert_equal load_average["load_five"], 0.14
    assert_equal load_average["load_fifteen"], 0.10
  end

  def test_memory
    HealthMode::MemoryMetric.stubs(:get_system_metrics).returns <<-sys_output
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

  def test_swap
    HealthMode::SwapMetric.stubs(:get_system_metrics).returns <<-sys_output
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

  def test_disk_usage
    HealthMode::DiskSpaceMetric.stubs(:get_system_metrics).returns <<-sys_output
Filesystem         1024-blocks      Used Available Capacity Mounted on
/dev/sda2             19222656  15440068   2806052      85% /
none                    995424       728    994696       1% /dev
none                   1002052      1096   1000956       1% /dev/shm
none                   1002052       132   1001920       1% /var/run
none                   1002052         0   1002052       0% /var/lock
/dev/sda4            198071540  80614372 107395652      43% /home
total                221295776  96056396 114201328      46%
    sys_output
    get "/disk_space.json"
    disk_usage = JSON.parse last_response.body
    assert_equal disk_usage["disk_total"], 221295776
    assert_equal disk_usage["disk_used"], 96056396
    assert_equal disk_usage["disk_free"], 114201328
    assert_equal disk_usage["disk_percentage_capacity"], 46
  end

  def test_number_of_users
    HealthMode::UserMetric.stubs(:get_system_metrics).returns <<-sys_output
zan
# users=10
    sys_output
    get "/users.json"
    users_usage = JSON.parse last_response.body
    assert_equal users_usage["users_num"], 10
  end

  def test_cpu_stat
    HealthMode::CPUMetric.stubs(:get_system_metrics).returns <<-sys_output
Linux 2.6.38-12-generic (zan-thinkpad)  25/11/2011      _i686_  (2 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          11.48    0.32    4.38    6.02    0.00   77.80
    sys_output
    get "/cpu.json"
    cpu_usage = JSON.parse last_response.body
    assert_equal cpu_usage["cpu_user"], 11.48
    assert_equal cpu_usage["cpu_nice"], 0.32
    assert_equal cpu_usage["cpu_system"], 4.38
    assert_equal cpu_usage["cpu_iowait"], 6.02
    assert_equal cpu_usage["cpu_steal"], 0.00
    assert_equal cpu_usage["cpu_idle"], 77.80
  end

  def test_disk_io_stat
    HealthMode::DiskIOMetric.stubs(:get_system_metrics).returns <<-sys_output
Linux 2.6.38-12-generic (zan-thinkpad)  25/11/2011      _i686_  (2 CPU)

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              22.43       765.02        65.49    1055856      90384
    sys_output
    get "/disk_io.json"
    disk_io_usage = JSON.parse last_response.body
    assert_equal disk_io_usage["disk_read_per_s"], 765.02
    assert_equal disk_io_usage["disk_write_per_s"], 65.49
    assert_equal disk_io_usage["disk_read"], 1055856
    assert_equal disk_io_usage["disk_write"], 90384
  end

  def test_processes
    HealthMode::ProcessMetric.stubs(:get_system_metrics).returns("0.18 0.14 0.10 1/419 6130")
    get "/process.json"
    process_usage = JSON.parse last_response.body
    assert_equal process_usage["proc_run"], 1
    assert_equal process_usage["proc_total"], 419
  end

  def test_network_io
    HealthMode::NetworkIOMetric.stubs(:get_previous_system_metrics).returns <<-sys_output
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
    lo:  430741    2815    0    0    0     0          0         0   430741    2815    0    0    0     0       0          0
  eth0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
 wlan0: 212395394  173050    0    0    0     0          0         0 15434201  120532    0    0    0     0       0          0
    sys_output

    HealthMode::NetworkIOMetric.stubs(:get_current_system_metrics).returns <<-sys_output
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
    lo:  430746    2815    0    0    0     0          0         0   430741    2815    0    0    0     0       0          0
  eth0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
 wlan0: 212395399  173060    0    0    0     0          0         0 15434221  120533    0    0    0     0       0          0
    sys_output
    get "/network_io.json"
    network_io_usage = JSON.parse last_response.body
    assert_equal network_io_usage["bytes_in"], 10
    assert_equal network_io_usage["bytes_out"], 20
    assert_equal network_io_usage["packets_in"], 10
    assert_equal network_io_usage["packets_out"], 1
  end

  def test_authentication
    HealthMode::Authentication.stubs(:from_authorized_host?).returns(true)
    get "/"
    assert_not_equal last_response.body, 'Unauthorized request'

    HealthMode::Authentication.stubs(:from_authorized_host?).returns(false)
    get "/"
    assert_equal last_response.body, 'Unauthorized request'
  end
end
