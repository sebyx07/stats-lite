# frozen_string_literal: true

module StatsLite
  DEFAULT_COMMANDS = {
    host: {
      hostname: "hostname",
      ip: {
        public: "curl -s ifconfig.me"
      }
    },
    cpu: {
      model: "lscpu | grep 'Model name' | cut -f 2 -d \":\" | awk '{$1=$1}1'",
      cores: "nproc",
      usage: <<-CMD
(grep 'cpu ' /proc/stat;sleep 0.1;grep 'cpu ' /proc/stat)|awk -v RS="" '{print ""($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5)"%"}'
      CMD
    }
  }
end
