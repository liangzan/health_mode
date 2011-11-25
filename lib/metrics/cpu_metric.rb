class CPUMetric < Metric
  class << self
    attr_accessor :system_metrics,
    :cpu_user,
    :cpu_nice,
    :cpu_system,
    :cpu_iowait,
    :cpu_steal,
    :cpu_idle

    def current_state
      refresh_state
      {
        "cpu_user" => @cpu_user,
        "cpu_nice" => @cpu_nice,
        "cpu_system" => @cpu_system,
        "cpu_iowait" => @cpu_iowait,
        "cpu_steal" => @cpu_steal,
        "cpu_idle" => @cpu_idle
      }
    end

    protected

    def refresh_state
      set_system_metrics
      match_system_metrics
    end

    def get_system_metrics
      `iostat -c`
    end

    def set_system_metrics
      @system_metrics = get_system_metrics
    end

    def metrics_regexp
      /\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)/
    end

    def match_system_metrics
      metrics_match = metrics_regexp.match(@system_metrics)
      @cpu_user = metrics_match[1].to_f
      @cpu_nice = metrics_match[2].to_f
      @cpu_system = metrics_match[3].to_f
      @cpu_iowait = metrics_match[4].to_f
      @cpu_steal = metrics_match[5].to_f
      @cpu_idle = metrics_match[6].to_f
    end
  end
end
