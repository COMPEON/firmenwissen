require 'spec_helper'

describe Firmenwissen::Response::Mock do
  describe '#new' do
    let(:test_object) do
      Class.new do
        def call(*)
          []
        end
      end.new
    end

    it 'works with arrays' do
      expect { described_class.new([], '') }.to_not raise_exception
    end

    it 'works with hashes' do
      expect { described_class.new({}, '') }.to_not raise_exception
    end

    it 'works with procs' do
      expect { described_class.new(Proc.new { [] }, '') }.to_not raise_exception
    end

    it 'works with classes implementing `call`' do
      expect { described_class.new(test_object, '') }.to_not raise_exception
    end
  end

  describe '#suggestions' do
    context 'with an array' do
      it 'returns a fixed array of suggestions' do
        expect(described_class.new([{}, {}], '').suggestions.size).to eq(2)
      end
    end

    context 'with a hash' do
      context 'with no matching key' do
        it 'returns an empty array' do
          expect(described_class.new({ test: [{}] }, '').suggestions.size).to eq(0)
        end
      end

      context 'with a matching key' do
        it 'returns a suggestions array' do
          expect(described_class.new({ 'test' => [{}] }, 'test').suggestions.size).to eq(1)
        end
      end
    end

    context 'with a proc' do
      let(:query) { 'COMPEON' }
      let(:params) { { country: 'DE' } }
      let(:proc_or_lambda) { double(call: [{}, {}]) }

      it 'returns a suggestions array' do
        expect(described_class.new(proc_or_lambda, query, params).suggestions.size).to eq(2)
        expect(proc_or_lambda).to have_received(:call).with(query, params)
      end
    end
  end

  describe '#status_code' do
    it 'is always 200' do
      expect(described_class.new([], '').status_code).to eq('200')
    end
  end
end
