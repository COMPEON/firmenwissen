module Firmenwissen
  module Session
    module_function

    def cookies
      @cookies ||= {}
    end

    def update_from_set_cookie_headers(set_cookie_headers)
      return if set_cookie_headers.nil?

      set_cookie_headers.each do |header|
        name_and_value, _other_attrs = header.split(/;\s?/)
        name, value = name_and_value.split('=', 2)

        next if name.empty? || value.nil? || value.empty?

        cookies[name] = value
      end
    end

    def to_cookie_string
      cookies.map { |entry| [entry].join('=') }.join('; ')
    end
  end
end
