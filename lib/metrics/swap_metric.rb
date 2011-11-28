module HealthMode
  class SwapMetric < HealthMode::Metric
    class << self
      attr_accessor :system_metrics,
      :total_memory,
      :used_memory,
      :free_memory

      def current_state
        refresh_state
        {
          "swap_total" => @total_memory,
          "swap_used" => @used_memory,
          "swap_free" => @free_memory
        }
      end

      protected

      def refresh_state
        set_system_metrics
        match_system_metrics
      end

      def get_system_metrics
        `free`
      end

      def set_system_metrics
        @system_metrics = get_system_metrics
      end

      def metrics_regexp
        /Swap\:\s+(\d+)\s+(\d+)\s+(\d+)/
      end

      def match_system_metrics
        metrics_match = metrics_regexp.match(@system_metrics)
        @total_memory = metrics_match[1].to_i
        @used_memory = metrics_match[2].to_i
        @free_memory = metrics_match[3].to_i
      end
    end
  end
end
