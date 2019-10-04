# frozen_string_literal: true

module StatsLite
  module Default
    class << self
      def host
        {
          hostname: h.command(df_c[:host][:hostname], cache: true),
          ip: ip
        }
      end
      def cpu
        {
          model: h.command(df_c[:cpu][:model], cache: true),
          cores: h.command(df_c[:cpu][:cores], cache: true),
          usage: _cpu_usage
        }
      end

      def ip
        {
          public: h.command(df_c[:host][:ip][:public], cache: true)
        }
      end

      def ram
        result = -> do
          map = Vidibus::Sysinfo.memory.to_h
          map.map do |k, v|
            map[k] = "#{(v / 1024.to_f).round(2)}GB"
          end
          map
        end

        { usage: h.fetch(:ram, result, expires_in: 10) }
      end

      def _cpu_usage
        {
          total: fmt_nr(h.command(df_c[:cpu][:usage]))
        }
      end

      def hdd
        result = -> do
          map =  Vidibus::Sysinfo.storage.to_h
          map.map do |k, v|
            map[k] = "#{v}GB"
          end

          map
        end

        { usage: h.fetch(:hdd, result, expires_in: 60) }
      end

      def fmt_nr(number)
        "#{number.gsub("%", "").to_i}%"
      end

      def df_c
        StatsLite::DEFAULT_COMMANDS
      end

      def h
        StatsLite::Helper
      end
    end
  end
end
