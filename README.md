# Firmenwissen
A ruby gem to conveniently access the [Firmenwissen](www.firmenwissen.de) Smart Sign-Up API.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'firmenwissen'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install firmenwissen
```

## Usage
### Searching
```ruby
response = Firmenwissen.search('company xyz')

if response.successful?
  suggestions = response.suggestions
  ...
end
```

will give you an array of suggestions from Firmenwissen, if any, for the specified query string.

```ruby
suggestion = suggestions.first

suggestion.crefo_id # => '1234567890'
suggestion.name # => 'COMPEON GmbH'
suggestion.trade_name # => 'Compeon'
suggestion.country # => 'DE'
suggestion.state # => 'Nordrhein-Westfalen'
suggestion.zip_code # => '40211'
suggestion.city # => 'Düsseldorf'
suggestion.address # => 'Louise-Dumon-Straße 5'

suggestion.to_h # => { crefo_id: '1234567890', name: 'COMPEON GmbH', ... }
```
### Configuration
```ruby
Firmenwissen.configure do |config|
  config.user     = 'username'     # Username for Firmenwissen basic auth (required)
  config.password = 'password'     # Password for Firmenwissen basic auth (required)
  config.timeout  = 5              # Request timeout in seconds

  # Configure the endpoint yourself. %s will be replaced by the actual query
  config.endpoint = 'https://example.com/search?query={query}'
end
```
### Mocking results
In a non production-like environment you will not want to perform real requests to the API. Thus you can configure the gem to respond with mocked data.

```ruby
Firmenwissen.configure do |config|
  config.mock_requests = true

  # respond with a fixed array
  config.mock_data = [{ crefo_id: '1111111111', name: 'Test GmbH', ... }, { ... }, ...]

  # respond when a query matches an exact keyword
  # this will return a result mock when you search for 'compeon' or 'test', otherwise an empty result
  mock_data = {
    'compeon' => [{ crefo_id: '1234567890', name: 'COMPEON GmbH', ... }],
    'test' => [{ crefo_id: '1111111111', ... }]
  }

  config.mock_data = mock_data

  # generate your own dynamic response
  config.mock_data = Proc.new do |query|
    # your code for mock data generation here
  end

  # or

  class DynamicMockData
    def call(query)
      # your code for mock data generation here
    end
  end

  config.mock_data = DynamicMockData.new
end
```
**Note:** All configuration options can be overridden on a per-request basis by passing an options hash to the `search` method.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
