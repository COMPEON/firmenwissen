module Firmenwissen
  module Response
    class Base
      attr_reader :suggestions

      def initialize(http_response)
        @http_response = http_response
        @suggestions = build_suggestions
      end

      def data
        @data ||= parsed_response.map { |hash| map_keys(hash) }
      rescue JSON::ParserError
        raise UnprocessableResponseError
      end

      def status_code
        http_response.code
      end

      def successful?
        status_code == '200'
      end

      private

      attr_reader :http_response

      def build_suggestions
        data.map { |suggestion| Suggestion.new(suggestion) }
      end

      def map_keys(hash)
        KeyMapper.from_api(hash)
      end

      def parsed_response
        JSON.parse(http_response.body).fetch('companyNameSuggestions', [])
      end
    end
  end
end
