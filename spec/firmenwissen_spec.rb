require 'spec_helper'

describe Firmenwissen do
  include ConfigurationHelper

  it 'has a version number' do
    expect(Firmenwissen::VERSION).to_not be_nil
  end

  describe '.search' do
    let(:request_mock) { double(execute: true) }

    context 'with a real request' do
      before do
        allow(Firmenwissen::Request::Base).to receive(:new).and_return(request_mock)
      end

      it 'instantiates a real request' do
        Firmenwissen.search('test')

        expect(Firmenwissen::Request::Base).to have_received(:new).once
      end
    end

    context 'with a mocked request' do
      before do
        mock_configuration do |config|
          config.mock_requests = true
        end

        allow(Firmenwissen::Request::Mock).to receive(:new).and_return(request_mock)
      end

      it 'instantiates a mocked request' do
        Firmenwissen.search('test')

        expect(Firmenwissen::Request::Mock).to have_received(:new).once
      end
    end
  end
end
