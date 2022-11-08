require 'logger'
require 'logstash-event'

module LogStasher
  class << self
    attr_reader :append_fields_callback
    attr_writer :enabled
    attr_writer :include_parameters
    attr_writer :serialize_parameters
    attr_writer :silence_standard_logging
    attr_accessor :metadata
    attr_accessor :prefix

    def append_fields(&block)
      @append_fields_callback = block
    end

    def enabled?
      if @enabled.nil?
        @enabled = false
      end

      @enabled
    end

    def include_parameters?
      if @include_parameters.nil?
        @include_parameters = true
      end

      @include_parameters
    end

    def serialize_parameters?
      if @serialize_parameters.nil?
        @serialize_parameters = true
      end

      @serialize_parameters
    end

    def initialize_logger(device = $stdout, level = ::Logger::INFO)
      ::Logger.new(device).tap do |new_logger|
        new_logger.level = level
      end
    end

    def log_as_json(payload, as_logstash_event: false)
      payload = payload.dup
      payload.merge!(:metadata => metadata) if !metadata&.empty? && payload.is_a?(::Hash)

      # Wrap the hash in a logstash event if the caller wishes for a specific
      # formatting applied to the hash. This is used by log subscriber, for
      # example.
      json_payload = if as_logstash_event
                       ::LogStash::Event.new(payload).to_json
                     else
                       payload.to_json
                     end

      logger << (prefix.nil? ? "" : prefix) + json_payload + $INPUT_RECORD_SEPARATOR
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
