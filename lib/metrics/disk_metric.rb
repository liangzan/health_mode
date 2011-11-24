class DiskMetric < Metric
  class << self
    def current_state
      {
        "disk_total" => total_disk_space,
        "disk_used" => used_disk_space,
        "disk_free" => free_disk_space,
        "disk_percentage_capacity" => percentage_capacity_disk_space
      }
    end

    protected

    def total_disk_space
      system_output_match[1].to_i
    end

    def used_disk_space
      system_output_match[2].to_i
    end

    def free_disk_space
      system_output_match[3].to_i
    end

    def percentage_capacity_disk_space
      system_output_match[4].to_i
    end

    def system_output
      `df --total -P --sync`
    end

    def output_regexp
      /total\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/
    end

    def system_output_match
      output_regexp.match(system_output)
    end
  end
end
