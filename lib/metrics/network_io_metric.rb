module BroadcastMode
  class NetworkIOMetric < BroadcastMode::Metric
    class << self
      attr_accessor :curr_system_metrics,
      :prev_system_metrics,
      :curr_bytes_in,
      :curr_bytes_out,
      :curr_packets_in,
      :curr_packets_out,
      :prev_bytes_in,
      :prev_bytes_out,
      :prev_packets_in,
      :prev_packets_out

      def current_state
        refresh_state
        {
          "bytes_in" => @curr_bytes_in - @prev_bytes_in,
          "bytes_out" => @curr_bytes_out - @prev_bytes_out,
          "packets_in" => @curr_packets_in - @prev_packets_in,
          "packets_out" => @curr_packets_out - @prev_packets_out
        }
      end

      protected

      def refresh_state
        set_previous_system_metrics
        match_previous_system_metrics
        set_current_system_metrics
        match_current_system_metrics
      end

      def get_system_metrics
        `cat /proc/net/dev`
      end

      def get_current_system_metrics
        sleep 1
        get_system_metrics
      end

      def get_previous_system_metrics
        get_system_metrics
      end

      def set_current_system_metrics
        @curr_system_metrics = get_current_system_metrics
      end

      def set_previous_system_metrics
        @prev_system_metrics = get_previous_system_metrics
      end

      def metrics_regexp
        /\s+(\d+)\s+(\d+)\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+(\d+)\s+(\d+)\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+/
      end

      def match_current_system_metrics
        @curr_system_metrics.split("\n").each do |line|
          metrics_match = metrics_regexp.match(line)
          if !metrics_match.nil?
            @curr_bytes_in = (@curr_bytes_in || 0) + metrics_match[1].to_i
            @curr_packets_in = (@curr_packets_in || 0) + metrics_match[2].to_i
            @curr_bytes_out = (@curr_bytes_out || 0) + metrics_match[3].to_i
            @curr_packets_out = (@curr_packets_out || 0) + metrics_match[4].to_i
          end
        end
      end

      def match_previous_system_metrics
        @prev_system_metrics.split("\n").each do |line|
          metrics_match = metrics_regexp.match(line)
          if !metrics_match.nil?
            @prev_bytes_in = (@prev_bytes_in || 0) + metrics_match[1].to_i
            @prev_packets_in = (@prev_packets_in || 0) + metrics_match[2].to_i
            @prev_bytes_out = (@prev_bytes_out || 0) + metrics_match[3].to_i
            @prev_packets_out = (@prev_packets_out || 0) + metrics_match[4].to_i
          end
        end
      end
    end
  end
end
