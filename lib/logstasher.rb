require 'logger'

module LogStasher
  class << self
    attr_reader :append_fields_callback
    attr_writer :enabled
    attr_writer :include_parameters
    attr_writer :silence_standard_logging

    def append_fields(&block)
      @append_fields_callback = block
    end

    def enabled?
      @enabled ||= false
    end

    def include_parameters?
      if @include_parameters.nil?
        @include_parameters = true
      end

      @include_parameters
    end

    def initialize_logger(device = $stdout, level = ::Logger::INFO)
      ::Logger.new(device).tap do |new_logger|
        new_logger.level = level
      end
    end

    def logger
      @logger ||= initialize_logger
    end

    def logger=(log)
      @logger = log
    end

    def silence_standard_logging?
      if @silence_standard_logging.nil?
        @silence_standard_logging = false
      end

      @silence_standard_logging
    end
  end
end

require 'logstasher/railtie' if defined?(Rails)
