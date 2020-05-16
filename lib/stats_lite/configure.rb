# frozen_string_literal: true

module StatsLite
  class Configuration
    def initialize
      @port = 9111
    end

    def port(_port = nil)
      _port ? @port = _port : @port
    end

    def rack(&block)
      return @rack unless block_given?
      @rack = block
    end

    def app
      _app = StatsLite::App
      if block_given?
        yield app
      else
        _app
      end
    end

    def password(_pass = nil)
      _pass ? @password = _pass : @password
    end

    def data(_data = nil)
      _data ? @data = _data : @data
    end

    def cron
      @rufus_wrapper ||= StatsLite::RufusWrapper.new
      yield @rufus_wrapper.instance
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
