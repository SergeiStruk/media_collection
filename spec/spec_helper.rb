RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.expect_with(:rspec) { |c| c.syntax = [:should, :expect] }

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
