require 'json'

# "{'foo': 'bar'}".should match_json {:foo => :bar}
RSpec::Matchers.define :match_json do |expected|
  match do |actual|
    ActiveSupport::JSON.decode(actual) == ActiveSupport::JSON.decode(expected.to_json)
  end
end
