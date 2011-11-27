$:.unshift (File.dirname(__FILE__) + '/lib')
require 'broadcast_mode'

run BroadcastMode::Agent.new
