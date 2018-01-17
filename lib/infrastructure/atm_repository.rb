# frozen_string_literal: true

module Infrastructure
  # Storage for ATMs
  class AtmRepository
    # @param collection [Array<Domain::Atm>] pre-initialized atms
    def initialize(collection: [])
      @collection = collection
    end

    # Checks if atm with given identity is exists
    # @param identity [String] identity to find
    # @retutn [Bool]
    def exists?(identity:)
      collection.any? { |atm| atm.identity == identity }
    end

    # Deletes ATM with given identity
    # @param identity [String] identity to find
    def delete(identity:)
      collection.delete_if { |atm| atm.identity == identity }
    end

    # Add indentity to storage
    # @param atm [Domain::Atm] new atm
    def add(atm)
      collection.push(atm)
    end

    # Find and return `count` nearest to `location` atms
    # @param location [#latitude, #longitude] geo-point
    # @param count [Integer] limit
    # @return [Array<Domain::Atm>]
    def nearest(location:, count:)
      collection.sort_by { |atm| atm.distance_to(location) }.first(count)
    end

    private

    attr_reader :collection
  end
end
