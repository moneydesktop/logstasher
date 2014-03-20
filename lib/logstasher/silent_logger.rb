module LogStasher
  module SilentLogger
    def logger
      unless @logstasher_silent_logger
        @logstasher_silent_logger       = ::Logger.new('/dev/null')
        @logstasher_silent_logger.level = ::Logger::UNKNOWN
      end

      @logstasher_silent_logger
    end
  end
end
