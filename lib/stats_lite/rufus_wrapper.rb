module StatsLite
  class RufusWrapper
    attr_reader :instance

    def initialize
      @instance = Rufus::Scheduler.new
    end
  end
end