# frozen_string_literal: true

module Domain
  # Service for removing atms
  class AtmRemover
    def initialize(repository:)
      @repository = repository
    end

    # Tries to remove {Atm} with given identity from repository
    #   throw :unknown_entity if Atm not exists
    # @param identity [String] atm-to-remove's identity
    def remove(identity:)
      throw(:unknown_atm) unless repository.exists?(identity: identity)

      repository.delete(identity: identity)
    end

    private

    attr_reader :repository
  end
end
