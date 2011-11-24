class MemoryMetric < Metric
  class << self
    def current_state
      {
        "mem_total" => total_memory,
        "mem_used" => used_memory,
        "mem_free" => free_memory,
        "mem_shared" => shared_memory,
        "mem_buffers" => buffers_memory,
        "mem_cached" => cached_memory,
        "mem_used_normalized" => normalized_used_memory,
        "mem_free_normalized" => normalized_free_memory
      }
    end

    protected

    def total_memory
      system_output_match[1].to_i
    end

    def used_memory
      system_output_match[2].to_i
    end

    def free_memory
      system_output_match[3].to_i
    end

    def shared_memory
      system_output_match[4].to_i
    end

    def buffers_memory
      system_output_match[5].to_i
    end

    def cached_memory
      system_output_match[6].to_i
    end

    def normalized_used_memory
      used_memory - shared_memory - buffers_memory - cached_memory
    end

    def normalized_free_memory
      total_memory - normalized_used_memory
    end

    def system_output
      `free`
    end

    def output_regexp
      /Mem\:\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+/
    end

    def system_output_match
      output_regexp.match(system_output)
    end
  end
end
