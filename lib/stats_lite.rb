# frozen_string_literal: true

require "sinatra"
require "json"
require "vidibus-sysinfo"

Dir[File.join(__dir__, "stats_lite", "**/*.rb")].each { |file| require file  }

module StatsLite
end
