module Firmenwissen
  module Request
    class Base
      def initialize(query, options = {})
        @query = query
        @options = options

        raise CredentialsError unless config.credentials_present?
      end

      def execute
        Response::Base.new(http_request.execute)
      end

      protected

      attr_reader :options, :query

      def http_request
        HttpRequest.new(uri, options)
      end

      def uri
        URI(format(config.endpoint, URI.escape(query)))
      end

      def config
        @config ||= Firmenwissen.configuration.merge(options)
      end
    end
  end
end
