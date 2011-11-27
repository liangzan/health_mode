module BroadcastMode
  class MemoryMetric < BroadcastMode::Metric
    class << self
      attr_accessor :system_metrics,
      :total_memory,
      :used_memory,
      :free_memory,
      :shared_memory,
      :buffers_memory,
      :cached_memory,
      :normalized_free_memory,
      :normalized_used_memory

      def current_state
        refresh_state
        {
          "mem_total" => @total_memory,
          "mem_used" => @used_memory,
          "mem_free" => @free_memory,
          "mem_shared" => @shared_memory,
          "mem_buffers" => @buffers_memory,
          "mem_cached" => @cached_memory,
          "mem_used_normalized" => @normalized_used_memory,
          "mem_free_normalized" => @normalized_free_memory
        }
      end

      protected

      def refresh_state
        set_system_metrics
        match_system_metrics
      end

      def set_system_metrics
        @system_metrics = get_system_metrics
      end

      def get_system_metrics
        `free`
      end

      def metrics_regexp
        /Mem\:\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+/
      end

      def match_system_metrics
        metrics_match = metrics_regexp.match(@system_metrics)
        @total_memory = metrics_match[1].to_i
        @used_memory = metrics_match[2].to_i
        @free_memory = metrics_match[3].to_i
        @shared_memory = metrics_match[4].to_i
        @buffers_memory = metrics_match[5].to_i
        @cached_memory = metrics_match[6].to_i
        @normalized_used_memory = @used_memory - @shared_memory - @buffers_memory - @cached_memory
        @normalized_free_memory = @total_memory - @normalized_used_memory
      end
    end
  end
end
