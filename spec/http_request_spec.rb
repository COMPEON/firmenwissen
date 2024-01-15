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

    let(:http_get_mock) do
      double(add_field: true, basic_auth: true)
    end

    before do
      allow(Net::HTTP).to receive(:start).with('example.com', 80, use_ssl: false).and_return(http_mock)
      allow(Net::HTTP::Get).to receive(:new).with(decorated_uri).and_return(http_get_mock)
    end

    describe 'when authentication strategy is basic' do
      let(:options) { { user: 'user', password: 'password', timeout: 10, authentication_strategy: 'basic' } }

      it 'configures basic auth' do
        subject.execute
        expect(http_get_mock).to have_received(:basic_auth).with(options[:user], options[:password])
        expect(http_get_mock).not_to have_received(:add_field).with('API-KEY', options[:api_key])
      end
    end

    describe 'when authentication strategy is api_key' do
      let(:options) { { api_key: 'my-api-key', timeout: 10, authentication_strategy: 'api_key' } }

      it 'configures api key authentication' do
        subject.execute
        expect(http_get_mock).to have_received(:add_field).with('API-KEY', options[:api_key])
        expect(http_get_mock).not_to have_received(:basic_auth)
      end
    end

    describe 'when authentication strategy is not provided' do
      it 'defaults and configures basic auth' do
        subject.execute
        expect(http_get_mock).to have_received(:basic_auth).with(options[:user], options[:password])
        expect(http_get_mock).not_to have_received(:add_field).with('API-KEY', options[:api_key])
      end
    end

    it 'fires the request' do
      subject.execute
      expect(http_mock).to have_received(:read_timeout=).with(options[:timeout])
      expect(http_mock).to have_received(:request).with(http_get_mock)
      expect(http_mock).to have_received(:finish)
    end

    describe 'when persisting sessions' do
      let(:options) { { user: 'user', password: 'password', timeout: 10, persistent_session: true } }

      before do
        allow(Firmenwissen::Session).to receive(:to_cookie_string).and_return(session_cookie)
      end

      context 'when session information is present' do
        let(:session_cookie) { 'JSESSION=foobar; SERVERID_SEARCH=barfoo' }

        it 'appends the session cookies' do
          subject.execute
          expect(http_get_mock).to have_received(:add_field).with('Cookie', 'JSESSION=foobar; SERVERID_SEARCH=barfoo')
        end
      end

      context 'when no session information is present' do
        let(:session_cookie) { '' }

        it 'does not append any cookies' do
          subject.execute
          expect(http_get_mock).not_to have_received(:add_field)
        end
      end
    end
  end
end
