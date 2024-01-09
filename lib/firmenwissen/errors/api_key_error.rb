module Firmenwissen
  class ApiKeyError < StandardError
    def initialize(message = 'Firmenwissen API Key is missing')
      super
    end
  end
end
