# frozen_string_literal: true

module Domain
  # Service for creating atms
  class AtmCreator
    def initialize(factory:, repository:)
      @factory = factory
      @repository = repository
    end

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
