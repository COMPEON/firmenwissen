require 'firmenwissen'
require 'vcr'
require 'webmock/rspec'

Dir['spec/support/**/*.rb'].each { |file| load file }

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.before_record do |record|
    record.request.headers.delete('Authorization')
  end
end
