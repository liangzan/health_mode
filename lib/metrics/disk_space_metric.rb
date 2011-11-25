class DiskSpaceMetric < Metric
  class << self
    attr_accessor :system_metrics,
    :total_disk_space,
    :used_disk_space,
    :free_disk_space,
    :percentage_capacity_disk_space

    def current_state
      refresh_state
      {
        "disk_total" => @total_disk_space,
        "disk_used" => @used_disk_space,
        "disk_free" => @free_disk_space,
        "disk_percentage_capacity" => @percentage_capacity_disk_space
      }
    end

    protected

    def refresh_state
      set_system_metrics
      match_system_metrics
    end

    def get_system_metrics
      `df --total -P --sync`
    end

    def set_system_metrics
      @system_metrics = get_system_metrics
    end

    def metrics_regexp
      /total\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/
    end

    def match_system_metrics
      metrics_match = metrics_regexp.match(@system_metrics)
      @total_disk_space = metrics_match[1].to_i
      @used_disk_space = metrics_match[2].to_i
      @free_disk_space = metrics_match[3].to_i
      @percentage_capacity_disk_space = metrics_match[4].to_i
    end
  end
end
