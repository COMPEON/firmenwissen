describe 'URIDecorator' do
  describe '#port' do
    subject { URIDecorator.new(Addressable::URI.parse(endpoint)).port }

    context 'with an https uri' do
      let(:endpoint) { 'https://www.firmenwissen.de' }

      it { is_expected.to eq(443) }
    end

    context 'with a non https uri' do
      let(:endpoint) { 'http://www.firmenwissen.de' }

      it { is_expected.to eq(80) }
    end

    context 'with an explicit port' do
      let(:endpoint) { 'http://www.firmenwissen.de:42' }

      it { is_expected.to eq(42) }
    end
  end

  describe '#use_ssl?' do
    subject { URIDecorator.new(Addressable::URI.parse(endpoint)).use_ssl? }

    context 'with an https uri' do
      let(:endpoint) { 'https://www.firmenwissen.de' }

      it { is_expected.to eq(true) }
    end

    context 'with a non https uri' do
      let(:endpoint) { 'http://www.firmenwissen.de' }

      it { is_expected.to eq(false) }
    end
  end
end
