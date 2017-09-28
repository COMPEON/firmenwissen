require 'spec_helper'

describe Firmenwissen::Configuration do
  it 'responds to all configuration options' do
    %i[endpoint password mock_data mock_requests timeout user].each do |setting|
      expect(described_class.new).to respond_to(setting)
    end
  end

  describe '#credentials_present?' do
    it 'validates the credentials' do
      expect(described_class.new(user: 'user', password: 'pass').credentials_present?).to eq(true)
      expect(described_class.new(user: '', password: 'pass').credentials_present?).to eq(false)
      expect(described_class.new(user: 'user', password: '').credentials_present?).to eq(false)
      expect(described_class.new(user: 'user', password: nil).credentials_present?).to eq(false)
    end
  end

  describe '#merge' do
    subject do
      described_class
        .new(mock_requests: true, mock_data: [{}])
        .merge(mock_requests: false)
    end

    it 'merges the settings' do
      expect(subject.mock_requests).to eq(false)
      expect(subject.mock_data.size).to eq(1)
    end
  end

  describe Firmenwissen::Configuration::Accessors do
    let(:test_class) do
      Class.new do
        extend Firmenwissen::Configuration::Accessors
      end
    end

    it 'extends the main module' do
      expect(Firmenwissen.ancestors).to include(described_class)
      expect(Firmenwissen).to respond_to(:configuration)
      expect(Firmenwissen).to respond_to(:configure)
    end

    describe '.configuration' do
      let(:configuration_mock) { double }

      subject { test_class }

      before do
        allow(Firmenwissen::Configuration).to receive(:new).and_return(configuration_mock)
      end

      it 'returns a Configuration object' do
        expect(subject.configuration).to eq(configuration_mock)
      end
    end
  end
end
