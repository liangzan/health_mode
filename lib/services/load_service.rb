class LoadService < Service
  class << self
    def current_state
      {
        "one_minute" => one_minute_load_average,
        "five_minutes" => five_minutes_load_average,
        "fifteen_minutes" => fifteen_minutes_load_average
      }
    end

    def one_minute_load_average
      system_output_match[1]
    end

    def five_minutes_load_average
      system_output_match[2]
    end

    def fifteen_minutes_load_average
      system_output_match[3]
    end

    protected

    def system_output
      `uptime`
    end

    def output_regexp
      /load\saverage\:\s(\d+\.\d+),\s(\d+\.\d+),\s(\d+\.\d+)/
    end

    def system_output_match
      output_regexp.match(system_output)
    end
  end
end
