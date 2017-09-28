module Firmenwissen
  class CredentialsError < StandardError
    def initialize(message = 'Firmenwissen credentials are missing')
      super
    end
  end
end
