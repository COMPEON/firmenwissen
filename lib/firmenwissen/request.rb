module Firmenwissen
  module Request
    class << self
      def from_strategy(strategy, query, options = {})
        strategy_name = strategy.to_s.capitalize

        self.const_get(strategy_name).new(query, options)
      end
    end
  end
end
