module JSONAPIMatcher
  class Validator

    attr_reader :content
    attr_reader :key

    def initialize(options: {})
      @key = options[:key]
    end

    def valid?(candidate)
      _set_content(candidate)
      _validate
    end

    def _set_content(candidate)
      @content = key ? candidate[key.to_s] : candidate
    end

  end
end
