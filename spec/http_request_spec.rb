require 'spec_helper'

describe Firmenwissen::HttpRequest do
  let(:uri) { Addressable::URI.parse('http://example.com/test') }
  let(:decorated_uri) { URIDecorator.new(uri) }
  let(:options) { { user: 'user', password: 'password', timeout: 10 } }

  subject { described_class.new(decorated_uri, options) }

  describe '#execute' do
    let(:http_mock) do
      double(
        :read_timeout= => true,
        :request       => true,
        :finish        => true
      )
    end
    let(:http_get_mock) { double(basic_auth: true) }

    before do
      allow(Net::HTTP).to receive(:start).with('example.com', 80, use_ssl: false).and_return(http_mock)
      allow(Net::HTTP::Get).to receive(:new).with(decorated_uri).and_return(http_get_mock)

      subject.execute
    end

    it 'configures basic auth' do
      expect(http_get_mock).to have_received(:basic_auth).with(options[:user], options[:password])
    end

    it 'fires the request' do
      expect(http_mock).to have_received(:read_timeout=).with(options[:timeout])
      expect(http_mock).to have_received(:request).with(http_get_mock)
      expect(http_mock).to have_received(:finish)
    end
  end
end
