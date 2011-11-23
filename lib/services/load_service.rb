class LoadService < Service
  class << self
    def current_state
      {
        "load_one" => one_minute_load_average,
        "load_five" => five_minutes_load_average,
        "load_fifteen" => fifteen_minutes_load_average
      }
    end

    protected

    def one_minute_load_average
      system_output_match[1]
    end

    def five_minutes_load_average
      system_output_match[2]
    end

    def fifteen_minutes_load_average
      system_output_match[3]
    end

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
