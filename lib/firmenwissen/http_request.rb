module Firmenwissen
  class HttpRequest
    def initialize(uri, options = {})
      @uri = uri
      @options = options
    end

    def execute
      http = Net::HTTP.start(uri.host)
      http.read_timeout = config.timeout
      http.request(request)
    ensure
      http.finish
      http
    end

    protected

    attr_reader :uri, :options, :params

    def request
      @request ||= begin
        Net::HTTP::Get.new(uri).tap do |req|
          req.basic_auth(config.user, config.password)
        end
      end
    end

    def config
      @config ||= Firmenwissen.configuration.merge(options)
    end
  end
end
