module Firmenwissen
  class UnprocessableResponseError < RuntimeError
    def initialize(message = 'The response from Firmenwissen could not be processed')
      super
    end
  end
end
