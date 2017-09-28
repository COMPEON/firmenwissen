module Firmenwissen
  class Suggestion
    KeyMapper::KEY_MAPPINGS.keys.each do |key|
      define_method(key) do
        suggestion[key]
      end
    end

    def initialize(suggestion)
      @suggestion = suggestion
    end

    def to_h
      suggestion.dup
    end

    private

    attr_reader :suggestion
  end
end
