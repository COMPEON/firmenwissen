class URIDecorator < SimpleDelegator
  HTTPS_PORT = 443
  HTTP_PORT = 80

  # The addressable URI implementation does not set this to a default value, but
  # returns nil instead
  def port
    super || derive_port_from_scheme
  end

  def https?
    scheme == 'https'
  end

  alias use_ssl? https?

  private

  def derive_port_from_scheme
    https? ? HTTPS_PORT : HTTP_PORT
  end
end
