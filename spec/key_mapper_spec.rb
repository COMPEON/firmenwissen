require 'spec_helper'

describe Firmenwissen::KeyMapper do
  let(:hash) do
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
  let(:api_hash) do
    {
      'crefonummer'       => '9876543210',
      'name'              => 'COMPEON GmbH',
      'handelsName'       => 'Compeon GmbH',
      'land'              => 'DE',
      'bundesland'        => 'Nordrhein-Westfalen',
      'plz'               => '40211',
      'ort'               => 'Düsseldorf',
      'strasseHausnummer' => 'Louise-Dumont-Straße 5'
    }
  end

  describe '.from_api' do
    subject { described_class.from_api(api_hash) }

    it { is_expected.to eq(hash) }
  end

  describe '.to_api' do
    subject { described_class.to_api(hash) }

    it { is_expected.to eq(api_hash) }
  end
end
