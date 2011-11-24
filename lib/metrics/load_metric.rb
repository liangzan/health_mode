class LoadMetric < Metric
  class << self
    attr_accessor :system_metrics,
    :one_minute_load_average,
    :five_minutes_load_average,
    :fifteen_minutes_load_average

    def current_state
      refresh_state
      {
        "load_one" => @one_minute_load_average,
        "load_five" => @five_minutes_load_average,
        "load_fifteen" => @fifteen_minutes_load_average
      }
    end

    protected

    def refresh_state
      set_system_metrics
      match_system_metrics
    end

    def get_system_metrics
      `cat /proc/loadavg`
    end

    def set_system_metrics
      @system_metrics = get_system_metrics
    end

    def metrics_regexp
      /^(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+/
    end

    def match_system_metrics
      metrics_match = metrics_regexp.match(@system_metrics)
      @one_minute_load_average = metrics_match[1].to_f
      @five_minutes_load_average = metrics_match[2].to_f
      @fifteen_minutes_load_average = metrics_match[3].to_f
    end
  end
end
