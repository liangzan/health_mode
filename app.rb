require "rubygems"
require "bundler/setup"
require "sinatra"
require "json"
require File.expand_path(File.dirname(__FILE__) + '/lib/broadcast_mode')

get "/" do
  "Hello Broadcast Mode"
end

get "/load.json" do
  content_type :json
  LoadMetric.current_state.to_json
end

get "/memory.json" do
  content_type :json
  MemoryMetric.current_state.to_json
end

get "/swap.json" do
  content_type :json
  SwapMetric.current_state.to_json
end
