module Firmenwissen
  module Request
    class Mock < Base
      def execute
        Response::Mock.new(config.mock_data, query, params)
      end
    end
  end
end
