# frozen_string_literal: true

module Domain
  # Factory for ATMs
  class AtmFactory
    # @param point_factory [#build] factory for {Point}
    def initialize(point_factory: Point)
      @point_factory = point_factory
    end

    # @param identity [String] new ATM's identity
    # @param latitude [Numeric] new ATM's latitude
    # @param longitude [Numeric] new ATM's longitude
    def build(identity:, latitude:, longitude:)
      throw(:invalid_params) unless identity.is_a?(String)
      throw(:invalid_params) if identity.empty?

      Atm.new(identity: identity, point: build_point(latitude, longitude))
    end

    # @param params [Array<Hash>] collection of params for building ATM
    # @see #build
    def build_multiple(params)
      throw(:invalid_params) unless params.is_a?(Array)

      params.map do |atm_params|
        build(atm_params)
      end
    end

    private

    attr_reader :point_factory

    def build_point(latitude, longitude)
      point_factory.build(latitude: latitude, longitude: longitude)
    end
  end
end
