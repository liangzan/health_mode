module HealthMode
  class DiskSpaceMetric < HealthMode::Metric
    class << self
      attr_accessor :system_metrics,
      :total_disk_space,
      :used_disk_space,
      :free_disk_space,
      :percentage_disk_space_used

      def current_state
        refresh_state
        {
          "disk_total" => @total_disk_space,
          "disk_used" => @used_disk_space,
          "disk_free" => @free_disk_space,
          "disk_used_percentage" => @percentage_disk_space_used
        }
      end

      protected

      def refresh_state
        set_system_metrics
        match_system_metrics
      end

      def get_system_metrics
        `df`
      end

      def set_system_metrics
        @system_metrics = get_system_metrics
      end

      def metrics_regexp
        /\S+\s+(\d+)\s+(\d+)\s+(\d+)\s+\d+/
      end

      def match_system_metrics
        @system_metrics.split("\n").each do |line|
          metrics_match = metrics_regexp.match(line)
          if !metrics_match.nil?
            @total_disk_space = (@total_disk_space || 0) + metrics_match[1].to_i
            @used_disk_space = (@used_disk_space || 0) + metrics_match[2].to_i
            @free_disk_space = (@free_disk_space || 0) + metrics_match[3].to_i
          end
        end
        @percentage_disk_space_used = (@used_disk_space.to_f / @total_disk_space.to_f * 100).round
      end
    end
  end
end
