module HealthMode
  class CPUMetric < HealthMode::Metric
    class << self
      attr_accessor :system_metrics,
      :cpu_user,
      :cpu_nice,
      :cpu_system,
      :cpu_iowait,
      :cpu_irq,
      :cpu_idle,
      :cpu_softirq

      def current_state
        refresh_state
        {
          "cpu_user" => @cpu_user,
          "cpu_nice" => @cpu_nice,
          "cpu_system" => @cpu_system,
          "cpu_iowait" => @cpu_iowait,
          "cpu_irq" => @cpu_irq,
          "cpu_idle" => @cpu_idle,
          "cpu_softirq" => @cpu_softirq
        }
      end

      protected

      def refresh_state
        set_system_metrics
        match_system_metrics
      end

      def get_system_metrics
        `cat /proc/stat`
      end

      def set_system_metrics
        @system_metrics = get_system_metrics
      end

      def metrics_regexp
        /cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/
      end

      def match_system_metrics
        metrics_match = metrics_regexp.match(@system_metrics)
        total = (1..6).map { |index| metrics_match[index].to_i }.reduce(:+)
        @cpu_user = percentage_cpu_time(metrics_match[1], total)
        @cpu_nice = percentage_cpu_time(metrics_match[2], total)
        @cpu_system = percentage_cpu_time(metrics_match[3], total)
        @cpu_idle = percentage_cpu_time(metrics_match[4], total)
        @cpu_iowait = percentage_cpu_time(metrics_match[5], total)
        @cpu_irq = percentage_cpu_time(metrics_match[6], total)
        @cpu_softirq = percentage_cpu_time(metrics_match[7], total)
      end

      def percentage_cpu_time(num, denom)
        (num.to_f / denom.to_f * 100.0).round(2)
      end
    end
  end
end
