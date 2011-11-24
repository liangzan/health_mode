class UserMetric < Metric
  class << self
    attr_accessor :system_metrics,
    :users_num

    def current_state
      refresh_state
      { "users_num" => @users_num }
    end

    protected

    def refresh_state
      set_system_metrics
      match_system_metrics
    end

    def get_system_metrics
      `who -q`
    end

    def set_system_metrics
      @system_metrics = get_system_metrics
    end

    def metrics_regexp
      /#\s+users=(\d+)/
    end

    def match_system_metrics
      metrics_match = metrics_regexp.match(@system_metrics)
      @users_num = metrics_match[1].to_i
    end
  end
end
