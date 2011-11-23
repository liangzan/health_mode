require File.expand_path(File.dirname(__FILE__) + '/service')
Dir[File.dirname(__FILE__) + "/services/*.rb"].each {|file| require file }

