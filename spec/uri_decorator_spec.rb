describe 'URIDecorator' do
  describe '#use_ssl?' do
    subject { URIDecorator.new(URI(endpoint)).use_ssl? }

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
