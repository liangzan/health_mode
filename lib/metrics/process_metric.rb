module BroadcastMode
  class ProcessMetric < BroadcastMode::Metric
    class << self
      attr_accessor :system_metrics,
      :proc_run,
      :proc_total

      def current_state
        refresh_state
        {
          "proc_total" => @proc_total,
          "proc_run" => @proc_run
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
        /^\d+\.\d+\s+\d+\.\d+\s+\d+\.\d+\s+(\d+)\/(\d+)\s+\d+/
      end

      def match_system_metrics
        metrics_match = metrics_regexp.match(@system_metrics)
        @proc_run = metrics_match[1].to_i
        @proc_total = metrics_match[2].to_i
      end
    end
  end
end
