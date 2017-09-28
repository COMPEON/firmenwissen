module Firmenwissen
  module KeyMapper
    KEY_MAPPINGS = {
      crefo_id:      'crefonummer',
      name:          'name',
      trade_name:    'handelsName',
      country:       'land',
      state:         'bundesland',
      zip_code:      'plz',
      city:          'ort',
      address:       'strasseHausnummer'
    }.freeze

    class << self
      def from_api(hash)
        map(hash, :from_api)
      end

      def to_api(hash)
        map(hash, :to_api)
      end

      private

      def map(hash, direction)
        {}.tap do |result|
          mapping_for(direction).each do |key, value|
            result[key] = hash[value]
          end
        end
      end

      def mapping_for(direction)
        direction == :from_api ? KEY_MAPPINGS : KEY_MAPPINGS.invert
      end
    end
  end
end
