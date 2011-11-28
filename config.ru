$:.unshift (File.dirname(__FILE__) + '/lib')
require 'health_mode'

run HealthMode::Agent.new
