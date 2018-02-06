class URIDecorator < SimpleDelegator
  def use_ssl?
    scheme == 'https'
  end
end
