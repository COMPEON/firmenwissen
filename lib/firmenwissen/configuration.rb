module Firmenwissen
  class Configuration
    module Accessors
      def configuration
        @config ||= Configuration.new
      end

      def configure
        yield configuration
      end
    end

    SETTINGS = %i[endpoint password mock_data mock_requests persistent_session timeout user authentication_strategy api_key]

    DEFAULT_SETTINGS = {
      endpoint: 'https://www.firmenwissen.de/search/suggest/companywithaddress/{query}{?country}',
      mock_requests: false,
      mock_data: [],
      persistent_session: false,
      timeout: 5,
      authentication_strategy: "basic"
    }.freeze

    SETTINGS.each do |setting|
      define_method(setting) do
        settings[setting]
      end

      define_method("#{setting}=") do |value|
        settings[setting] = value
      end
    end

    attr_reader :settings

    def initialize(options = {})
      @settings = DEFAULT_SETTINGS.dup.merge(options)
    end

    def merge(options)
      Configuration.new(settings.merge(options))
    end

    def credentials_present?
      [user, password].all? { |setting| setting.is_a?(String) && !setting.empty? }
    end

    def mock_requests?
      mock_requests
    end

    def persistent_session?
      persistent_session
    end

    def api_key_present?
      api_key.is_a?(String) && !api_key.empty?
    end
  end
end
