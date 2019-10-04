# frozen_string_literal: true

module StatsLite
  module Helper
    class << self
      def raw_command(command, options)
        proc = -> { _sys_command(command) }

        _cache(options, command, proc)
      end

      def command(command, options = {})
        proc = -> { _prepare_command(command) }

        _cache(options, command, proc)
      end

      def fetch(name, proc, expires_in: 0)
        _cache({ cache: true,  expires_in: expires_in }, name, proc)
      end

      def _cache(options, command, proc)
        expires_s = options[:expires_in] || 0

        options[:cache] ? Cache.fetch(command, proc, expires_s) : proc.call
      end

      def _sys_command(command)
        %x(#{command})
      end

      def _prepare_command(command)
        _sys_command(command).gsub("\n", " ").strip
      end
    end
  end
end
