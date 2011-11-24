class SwapService < Service
  class << self
    def current_state
      {
        "swap_total" => total_memory,
        "swap_used" => used_memory,
        "swap_free" => free_memory
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

    def system_output
      `free`
    end

    def output_regexp
      /Swap\:\s+(\d+)\s+(\d+)\s+(\d+)/
    end

    def system_output_match
      output_regexp.match(system_output)
    end
  end
end
