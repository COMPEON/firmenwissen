require 'spec_helper'

describe Firmenwissen::Request::Base do
  include ConfigurationHelper

  subject { Proc.new { described_class.new('test') } }

  context 'without credentials' do
    it { is_expected.to raise_exception(Firmenwissen::CredentialsError) }
  end

  context 'with credentials' do
    before { mock_configuration }

    it { is_expected.to_not raise_exception }

    describe '#execute' do
      let(:http_request_mock) { double(execute: true) }

      subject { described_class.new('test') }

      before do
        allow(Firmenwissen::Response::Base).to receive(:new)
        allow(Firmenwissen::HttpRequest).to receive(:new).and_return(http_request_mock)

        subject.execute
      end

      it 'creates an HttpRequest' do
        expect(Firmenwissen::HttpRequest).to have_received(:new).once
        expect(http_request_mock).to have_received(:execute).once
      end

      it 'returns a Response' do
        expect(Firmenwissen::Response::Base).to have_received(:new).with(http_request_mock.execute)
      end
    end

    describe '#uri' do
      let(:options) { {} }

      subject { described_class.new('test 123', options).__send__(:uri).to_s }

      before do
        mock_configuration do |config|
          config.endpoint = 'http://example-endpoint.com/{query}{?country}'
        end
      end

      it { is_expected.to eq('http://example-endpoint.com/test%20123') }

      context 'with params' do
        let(:options) { { params: { country: 'DE' } } }

        it 'adds the parameters to the uri' do
          expect(subject).to eq('http://example-endpoint.com/test%20123?country=DE')
        end
      end
    end
  end
end
