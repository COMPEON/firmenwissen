require 'spec_helper'

describe Firmenwissen::Suggestion do
  let(:suggestion_hash) do
    {
      crefo_id:      '9876543210',
      name:          'COMPEON GmbH',
      trade_name:    'Compeon GmbH',
      country:       'DE',
      state:         'Nordrhein-Westfalen',
      zip_code:      '40211',
      city:          'Düsseldorf',
      address:       'Louise-Dumont-Straße 5'
    }
  end

  subject { described_class.new(suggestion_hash) }

  describe 'dynamic methods' do
    it 'generates and maps the correct information' do
      suggestion_hash.keys.each do |key|
        expect(subject.__send__(key)).to eq(suggestion_hash[key])
      end
    end
  end
end
