class URIDecorator < SimpleDelegator
  HTTPS_PORT = 443
  HTTP_PORT = 80

  def derive_port_from_scheme
    use_ssl? ? HTTPS_PORT : HTTP_PORT
  end

  # The addressable URI implementation does not set this to a default value, but
  # returns nil instead
  def port
    super || derive_port_from_scheme
  end

  def use_ssl?
    scheme == 'https'
  end
end
