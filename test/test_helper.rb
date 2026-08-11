ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Add more helper methods to be used by all tests here...

    # for memoized helper methods in tests
    def self.let(name, &block)
      define_method(name) do
        @__memoized__ ||= {}
        @__memoized__[name] ||= instance_eval(&block)
      end
    end
  end
end
