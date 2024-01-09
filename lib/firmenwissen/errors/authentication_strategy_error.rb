module Firmenwissen
  class AuthenticationStrategyError < StandardError
    def initialize(message = 'Invalid authentication strategy')
      super
    end
  end
end
