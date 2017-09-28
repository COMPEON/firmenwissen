module Firmenwissen
  module Response
    class Base
      def initialize(http_response)
        @http_response = http_response
      end

      def suggestions
        @suggestions ||= data.map { |suggestion| Suggestion.new(suggestion) }
      end

      def data
        api_response = JSON.parse(http_response.body).fetch('companyNameSuggestions', [])

        map_response(api_response)
      end

      def status_code
        http_response.code
      end

      def successful?
        status_code == '200'
      end

      private

      attr_reader :http_response

      def map_response(api_response)
        api_response.map do |hash|
          KeyMapper.from_api(hash)
        end
      end
    end
  end
end
