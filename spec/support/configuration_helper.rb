module ConfigurationHelper
  def mock_configuration(with_credentials: true, &block)
    config = Firmenwissen::Configuration.new

    if with_credentials
      config.password = ENV['FIRMENWISSEN_PASSWORD'] || 'password'
      config.user     = ENV['FIRMENWISSEN_USER'] || 'user'
    end

    yield config if block_given?

    allow(Firmenwissen).to receive(:configuration).and_return(config)
  end
end
