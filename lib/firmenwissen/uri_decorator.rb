class URIDecorator < SimpleDelegator
  def port
    inferred_port
  end

  def use_ssl?
    scheme == 'https'
  end
end
