require 'spec_helper'

describe Firmenwissen::Response::Base do
  let(:http_response_stub) { double(body: suggestions.to_json) }
  let(:suggestions) do
    {
      'companyNameSuggestions' => [
        {
          'crefonummer'       => '9876543210',
          'name'              => 'COMPEON GmbH',
          'handelsName'       => 'Compeon GmbH',
          'land'              => 'DE',
          'bundesland'        => 'Nordrhein-Westfalen',
          'plz'               => '40211',
          'ort'               => 'Düsseldorf',
          'strasseHausnummer' => 'Louise-Dumont-Straße 5'
        },
        {
          'crefonummer'       => '0123456789',
          'name'              => 'Testfirma',
          'handelsName'       => 'Testfirma GmbH',
          'land'              => 'DE',
          'bundesland'        => 'Nordrhein-Westfalen',
          'plz'               => '40211',
          'ort'               => 'Düsseldorf',
          'strasseHausnummer' => 'Teststraße 42'
        }
      ]
    }
  end

  subject { described_class.new(http_response_stub) }

  describe '#suggestions' do
    context 'with a result list' do
      before do
        allow(Firmenwissen::Suggestion).to receive(:new)
      end

      it 'returns a list of suggestions' do
        expect(subject.suggestions.size).to eq(2)
        expect(Firmenwissen::Suggestion).to have_received(:new).exactly(2).times
      end
    end

    context 'with no results' do
      let(:http_response_stub) { double(body: { companyNameSuggestions: [] }.to_json) }

      it 'returns an empty list' do
        expect(subject.suggestions).to be_empty
      end
    end

    context 'with an invalid response' do
      let(:http_response_stub) { double(body: '<html></html>') }

      it 'throws an exception' do
        expect { subject }.to raise_exception(Firmenwissen::UnprocessableResponseError)
      end
    end
  end

  describe '#data' do
    let(:expected_result) do
      [
        Firmenwissen::KeyMapper.from_api(suggestions.fetch('companyNameSuggestions').first),
        Firmenwissen::KeyMapper.from_api(suggestions.fetch('companyNameSuggestions').last),
      ]
    end

    it 'returns mapped data' do
      expect(subject.data).to eq(expected_result)
    end
  end
end
