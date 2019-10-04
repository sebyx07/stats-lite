# frozen_string_literal: true

module StatsLite
  class Cache
    attr_reader :map

    def initialize
      @map = {}
    end

    class << self
      def fetch(name, proc, expires_s)
        @cache ||= new

        existing = @cache.map[name] if @cache.map.has_key?(name)

        if existing
          if existing.is_a?(Hash) && existing.has_key?(:timestamp)
            if Time.now - existing[:timestamp] > expires_s
              _handle_expires(name, proc)
            else
              existing[:value]
            end
          elsif expires_s > 0
            _handle_expires(name, proc)
          else
            _gey_key(name)
          end
        else
          if expires_s > 0
            _handle_expires(name, proc)
          else
            _set_key(name, proc)
          end
        end
      end

      def _handle_expires(name, proc)
        @cache.map[name] = { timestamp: Time.now, value: proc.call }
        @cache.map[name][:value]
      end

      def _set_key(name, proc)
        @cache.map[name] = proc.call
      end

      def _gey_key(name)
        @cache.map[name]
      end
    end
  end
end
