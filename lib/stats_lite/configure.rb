# frozen_string_literal: true

module StatsLite
  class Configuration
    def initialize
      @port = 9111
      @watch = ["config.rb"]
    end

    def port(_port = nil)
      _port ? @port = _port : @port
    end

    def app
      _app = StatsLite::App
      if block_given?
        yield app
      else
        _app
      end
    end

    def watch(_paths = nil)
      _paths ? @watch = _paths : @watch
    end

    def password(_pass = nil)
      _pass ? @password = _pass : @password
    end

    def data(_data = nil)
      _data ? @data = _data : @data
    end
  end

  class << self
    def configure
      config = @configuration ||= Configuration.new
      if block_given?
        yield config, StatsLite::Helper
      else
        config
      end
    end
  end
end
