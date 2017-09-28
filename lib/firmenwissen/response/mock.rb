module Firmenwissen
  module Response
    class Mock < Base
      def initialize(mock_data, query)
        @mock_data = mock_data
        @query = query

        raise ArgumentError, 'mock data must either be an array, a hash or respond to `call`' unless mock_data_valid?
      end

      def data
        return mock_data.call(query) if mock_data.respond_to?(:call)

        case mock_data
        when Array
          mock_data
        when Hash
          mock_data[query] || []
        else
          []
        end
      end

      def status_code
        '200'
      end

      private

      attr_reader :mock_data, :query

      def mock_data_valid?
        mock_data.respond_to?(:call) || mock_data.is_a?(Array) || mock_data.is_a?(Hash)
      end
    end
  end
end
