require "rubygems"
require "bundler/setup"
require "sinatra/base"
require "json"
$:.unshift File.dirname(__FILE__)
require 'metric'
require 'authentication'
Dir[File.dirname(__FILE__) + "/metrics/*.rb"].each {|file| require file }

module HealthMode
  class Agent < Sinatra::Base
    before do
      if !HealthMode::Authentication.from_authorized_host?(request)
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
      HealthMode::LoadMetric.current_state.to_json
    end

    get "/memory.json" do
      content_type :json
      HealthMode::MemoryMetric.current_state.to_json
    end

    get "/swap.json" do
      content_type :json
      HealthMode::SwapMetric.current_state.to_json
    end

    get "/disk_space.json" do
      content_type :json
      HealthMode::DiskSpaceMetric.current_state.to_json
    end

    get "/disk_io.json" do
      content_type :json
      HealthMode::DiskIOMetric.current_state.to_json
    end

    get "/users.json" do
      content_type :json
      HealthMode::UserMetric.current_state.to_json
    end

    get "/cpu.json" do
      content_type :json
      HealthMode::CPUMetric.current_state.to_json
    end

    get "/process.json" do
      content_type :json
      HealthMode::ProcessMetric.current_state.to_json
    end

    get "/network_io.json" do
      content_type :json
      HealthMode::NetworkIOMetric.current_state.to_json
    end
  end
end

