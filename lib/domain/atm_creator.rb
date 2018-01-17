# frozen_string_literal: true

module Domain
  # Service for creating atms
  class AtmCreator
    # @param factory [#build] factory for ATM
    def initialize(factory:, repository:)
      @factory = factory
      @repository = repository
    end

    # Process creation of new ATM
    # @param identity [String] new ATM's identity
    # @param latitude [Numeric] new ATM's latitude
    # @param longitude [Numeric] new ATM's longitude
    def create(identity:, latitude:, longitude:)
      throw(:identity_not_unique) if repository.exists?(identity: identity)

      atm = factory.build(identity: identity, latitude: latitude, longitude: longitude)

      repository.add(atm)

      atm
    end

    private

    attr_reader :factory, :repository
  end
end
