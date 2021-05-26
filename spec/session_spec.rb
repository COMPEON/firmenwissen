require 'spec_helper'

describe Firmenwissen::Session do
  describe '#update_from_set_cookie_headers' do
    subject { Firmenwissen::Session.update_from_set_cookie_headers(set_cookie_headers) }

    let(:initial_cookie_state) { {} }

    around(:each) do |example|
      Firmenwissen::Session.instance_variable_set(:@cookies, initial_cookie_state)
      example.run
      Firmenwissen::Session.instance_variable_set(:@cookies, {})
    end

    context 'when no set-cookie headers are passed' do
      let(:set_cookie_headers) { nil }

      it 'does not do anything' do
        expect { subject }.not_to change(Firmenwissen::Session, :cookies)
      end
    end

    context 'when malformed set-cookie headers are passed' do
      let(:set_cookie_headers) { ['WELLFORMED=COOKIE; Path=/', '=ONLY_VALUE', 'MALFORMED'] }

      it 'accepts only the wellformed cookies' do
        expect { subject }.to change(Firmenwissen::Session, :cookies).to({ 'WELLFORMED' => 'COOKIE' })
      end
    end

    context 'when empty values are passed' do
      let(:initial_cookie_state) { { 'JSESSION' => 'foobar', 'SERVERID_SEARCH' => 'barfoo' } }
      let(:set_cookie_headers) { ['JSESSION=; Path=/', 'SERVERID_SEARCH='] }

      it 'does not persist the cookie' do
        expect { subject }.not_to change(Firmenwissen::Session, :cookies)
      end
    end

    context 'when multiple set-cookie headers are passed' do
      let(:initial_cookie_state) { { 'JSESSION' => 'NOT foobar' } }
      let(:set_cookie_headers) { ['JSESSION=foobar; Path=/', 'SERVERID_SEARCH=barfoo'] }

      it 'persists all cookies and updates existing' do
        expected_cookie_state = { 'JSESSION' => 'foobar', 'SERVERID_SEARCH' => 'barfoo' }
        expect { subject }.to(change(Firmenwissen::Session, :cookies).to(expected_cookie_state))
      end
    end
  end

  describe '#to_cookie' do
    subject { Firmenwissen::Session.to_cookie }

    before do
      allow(Firmenwissen::Session).to receive(:cookies).and_return(persisted_cookies)
    end

    context 'when no cookies were stored' do
      let(:persisted_cookies) { {} }

      it { is_expected.to be_empty }
    end

    context 'when cookies were stored' do
      let(:persisted_cookies) { { 'KEY' => 'VALUE', 'OTHER_KEY' => 'OTHER_VALUE' } }

      it { is_expected.to eq('KEY=VALUE; OTHER_KEY=OTHER_VALUE') }
    end
  end
end
