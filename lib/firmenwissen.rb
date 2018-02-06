require 'json'
require 'net/http'
require 'addressable/template'

require 'firmenwissen/configuration'
require 'firmenwissen/http_request'
require 'firmenwissen/key_mapper'
require 'firmenwissen/request'
require 'firmenwissen/suggestion'
require 'firmenwissen/uri_decorator'
require 'firmenwissen/version'

require 'firmenwissen/errors/credentials_error'
require 'firmenwissen/errors/unprocessable_response_error'

require 'firmenwissen/request/base'
require 'firmenwissen/request/mock'

require 'firmenwissen/response/base'
require 'firmenwissen/response/mock'

module Firmenwissen
  extend Configuration::Accessors

  class << self
    def search(query, options = {})
      strategy = configuration.mock_requests? ? :mock : :base

      Request.from_strategy(strategy, query, options).execute
    end
  end
end
