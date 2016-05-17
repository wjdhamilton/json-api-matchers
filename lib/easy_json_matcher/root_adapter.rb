require "easy_json_matcher"
require "json"

module EasyJSONMatcher
  class RootAdapter

    attr_reader :node, :errors

    def initialize(node:, opts:{})
      @node = node
      @errors = []
    end

    def valid?(candidate)
      validate(candidate).empty?
    end

    def validate(candidate)
      errors = {}
      candidate = coerce(candidate, errors)
      return errors unless errors.empty?
      errors.merge(node.validate(candidate))
    end

    def coerce(candidate, errors)
      begin
        coerced = JSON.parse(candidate)
        symbolize_keys(hash: coerced)
      rescue JSON::ParserError
        errors[:root] = ["#{candidate} is not a valid JSON String"]
      end
    end

    def symbolize_keys(hash:)
      hash.keys.each do |key|
        value = hash.delete(key)
        convert_value(value)
        hash[key.to_sym] = value
      end
      hash
    end

    def convert_value(value)
      case value
      when Hash
        symbolize_keys(hash: value) if value.is_a? Hash
      when Array
        value.select {|val| val.is_a? Hash}.each {|h| symbolize_keys(hash: h) }
      end
    end
  end
end