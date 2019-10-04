# frozen_string_literal: true

module StatsLite
  module Default
    class << self
      def host
        {
          hostname: h.command("hostname", cache: true),
          ip: ip
        }
      end
      def cpu
        {
          model: h.command("lscpu | grep 'Model name' | cut -f 2 -d \":\" | awk '{$1=$1}1'", cache: true),
          cores: h.command("nproc", cache: true),
          usage: _cpu_usage
        }
      end

      def ip
        {
          public: h.command("curl -s ifconfig.me", cache: true)
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
        total = <<-CMD
(grep 'cpu ' /proc/stat;sleep 0.1;grep 'cpu ' /proc/stat)|awk -v RS="" '{print ""($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5)"%"}'
        CMD
        {
          total: fmt_nr(h.command(total))
        }
      end

      def hdd
        result = -> do
          map =  Vidibus::Sysinfo.storage.to_h
          map.map do |k, v|
            map[k] = "#{v}GB"
          end
        end

        { usage: h.fetch(:hdd, result, expires_in: 60) }
      end

      def fmt_nr(number)
        "#{number.gsub("%", "").to_i}%"
      end

      def h
        StatsLite::Helper
      end
    end
  end
end
