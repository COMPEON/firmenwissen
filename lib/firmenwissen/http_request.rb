module Firmenwissen
  class HttpRequest
    def initialize(uri, options = {})
      @uri = uri
      @options = options
    end

    def execute
      http = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.use_ssl?)
      http.read_timeout = config.timeout
      http.request(request, &method(:extract_session))
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
          req.add_field('Cookie', session_cookie) if config.persistent_session? && !session_cookie.empty?
        end
      end
    end

    def config
      @config ||= Firmenwissen.configuration.merge(options)
    end

    def extract_session(response)
      return unless config.persistent_session?

      Firmenwissen::Session.update_from_set_cookie_headers(response.get_fields('Set-Cookie'))
    end

    def session_cookie
      @session_cookie ||= Firmenwissen::Session.to_cookie_string
    end
  end
end
