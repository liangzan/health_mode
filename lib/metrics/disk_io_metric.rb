module BroadcastMode
  class DiskIOMetric < BroadcastMode::Metric
    class << self
      attr_accessor :system_metrics,
      :disk_read_per_s,
      :disk_write_per_s,
      :disk_read,
      :disk_write

      def current_state
        refresh_state
        {
          "disk_read_per_s" => @disk_read_per_s,
          "disk_write_per_s" => @disk_write_per_s,
          "disk_read" => @disk_read,
          "disk_write" => @disk_write
        }
      end

      protected

      def refresh_state
        set_system_metrics
        match_system_metrics
      end

      def get_system_metrics
        `iostat -d`
      end

      def set_system_metrics
        @system_metrics = get_system_metrics
      end

      def metrics_regexp
        /\s+\d+\.\d+\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+)\s+(\d+)/
      end

      def match_system_metrics
        metrics_match = metrics_regexp.match(@system_metrics)
        @disk_read_per_s = metrics_match[1].to_f
        @disk_write_per_s = metrics_match[2].to_f
        @disk_read = metrics_match[3].to_i
        @disk_write = metrics_match[4].to_i
      end
    end
  end
end
