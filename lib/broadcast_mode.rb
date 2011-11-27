require "rubygems"
require "bundler/setup"
require "sinatra/base"
require "json"
$:.unshift File.dirname(__FILE__)
require 'metric'
require 'authentication'
Dir[File.dirname(__FILE__) + "/metrics/*.rb"].each {|file| require file }

module BroadcastMode
  class Agent < Sinatra::Base
    before do
      if !BroadcastMode::Authentication.from_authorized_host?(request)
        request.path_info = "/unauthorized"
      end
    end

    get "/" do
      erb :index
    end

    get "/unauthorized" do
      'Unauthorized request'
    end

    get "/load.json" do
      content_type :json
      BroadcastMode::LoadMetric.current_state.to_json
    end

    get "/memory.json" do
      content_type :json
      BroadcastMode::MemoryMetric.current_state.to_json
    end

    get "/swap.json" do
      content_type :json
      BroadcastMode::SwapMetric.current_state.to_json
    end

    get "/disk_space.json" do
      content_type :json
      BroadcastMode::DiskSpaceMetric.current_state.to_json
    end

    get "/disk_io.json" do
      content_type :json
      BroadcastMode::DiskIOMetric.current_state.to_json
    end

    get "/users.json" do
      content_type :json
      BroadcastMode::UserMetric.current_state.to_json
    end

    get "/cpu.json" do
      content_type :json
      BroadcastMode::CPUMetric.current_state.to_json
    end

    get "/process.json" do
      content_type :json
      BroadcastMode::ProcessMetric.current_state.to_json
    end

    get "/network_io.json" do
      content_type :json
      BroadcastMode::NetworkIOMetric.current_state.to_json
    end
  end
end

