# frozen_string_literal: true

module Domain
  # Implements ATM entity
  class Atm
    attr_reader :identity

    # @param point [Point] geo location
    # @param identity [String] unique identifier
    def initialize(identity:, point:)
      @point = point
      @identity = identity
    end

    # Geo latitude
    # @return [Numerical]
    def latitude
      point.latitude
    end

    # Geo longitude
    # @return [Numerical]
    def longitude
      point.longitude
    end

    # Distance to other geo object in meters
    # @param other [#latitude, #longitude] geo-object to find distance to
    def distance_to(other)
      point.distance_to(other)
    end

    # Represent object as string
    # @return [String]
    def to_s
      "#{identity} (#{latitude}; #{longitude})"
    end

    private

    attr_reader :point
  end
end
