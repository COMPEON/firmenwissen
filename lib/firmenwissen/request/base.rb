module Firmenwissen
  module Request
    class Base
      def initialize(query, options = {})
        @query = query
        @options = options
        @params = options.fetch(:params, {})

        raise CredentialsError unless config.credentials_present?
      end

      def execute
        Response::Base.new(http_request.execute)
      end

      protected

      attr_reader :options, :query, :params

      def http_request
        HttpRequest.new(uri, options)
      end

      def uri
        template = Addressable::Template.new(config.endpoint)
        URIDecorator.new(template.expand(query: query, **params))
      end

      def config
        @config ||= Firmenwissen.configuration.merge(options)
      end
    end
  end
end
