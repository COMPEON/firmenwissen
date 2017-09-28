require 'spec_helper'

describe Firmenwissen::Request::Mock do
  include ConfigurationHelper

  let(:query) { 'test' }
  let(:mock_data) { [] }
  let(:response_mock) { double }

  subject { described_class.new(query) }

  before do
    mock_configuration do |config|
      config.mock_data = mock_data
    end

    allow(Firmenwissen::Response::Mock).to receive(:new).and_return(response_mock)
  end

  describe '#execute' do
    it 'returns a Response::Mock with mock data' do
      expect(subject.execute).to eq(response_mock)
      expect(Firmenwissen::Response::Mock).to have_received(:new).with(mock_data, query)
    end
  end
end
