require 'spec_helper'

shared_examples 'a request' do
  it 'returns a response' do
    expect(subject).to be_instance_of(Firmenwissen::Response::Base)
  end

  it 'generates a list of suggestions' do
    expect(subject.suggestions).to be_instance_of(Array)
  end
end

describe 'Request' do
  include ConfigurationHelper

  let(:query) { 'COMPEON GmbH' }
  let(:response) do
    VCR.use_cassette('request_with_results') do
      Firmenwissen::Request::Base.new(query).execute
    end
  end

  subject { response }

  before do
    mock_configuration
  end

  it_behaves_like 'a request'

  it 'is successful' do
    expect(subject).to be_successful
  end

  describe 'Suggestions list' do
    subject { response.suggestions }

    it 'returns an array of suggestions' do
      expect(subject.size).to eq(1)
      expect(subject.first).to be_instance_of(Firmenwissen::Suggestion)
    end
  end

  describe 'Suggestions' do
    subject { response.suggestions.first }

    it 'creates data accessors' do
      %i[crefo_id name trade_name country state zip_code city address].each do |accessor|
        expect(subject.__send__(accessor)).to eq(subject.to_h[accessor])
      end
    end
  end

  context 'with a request with no results' do
    let(:query) { 'Non existing company xyz' }
    let(:response) do
      VCR.use_cassette('request_without_results') do
        Firmenwissen::Request::Base.new(query).execute
      end
    end

    subject { response }

    it_behaves_like 'a request'

    it 'is successful' do
      expect(subject).to be_successful
    end

    describe 'Suggestions list' do
      subject { response.suggestions }

      it 'returns an empty suggestions array' do
        expect(subject).to be_empty
      end
    end
  end

  context 'with an unauthorized request' do
    let(:response) do
      VCR.use_cassette('unauthorized_request') do
        Firmenwissen::Request::Base.new(query).execute
      end
    end

    subject { response }

    it_behaves_like 'a request'

    before do
      mock_configuration do |config|
        config.user = 'wrong user'
        config.password = 'wrong password'
      end
    end

    it 'is not successful' do
      expect(subject).to_not be_successful
    end

    describe 'Suggestions list' do
      subject { response.suggestions }

      it 'returns an empty suggestions array' do
        expect(subject).to be_empty
      end
    end
  end
end
