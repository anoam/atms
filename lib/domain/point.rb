# frozen_string_literal: true

module Domain
  # Implements geo-point behaviour
  class Point
    RAD_PER_DEG = Math::PI / 180
    EARTH_RADIUS = 6_371_000

    attr_reader :latitude, :longitude

    # Check arguments and creates new instance
    # @param latitude [Numerical] geo latitude
    # @param longitude [Numerical] geo longitude
    # @return [Point]
    def self.build(latitude:, longitude:)
      throw(:invalid_params) unless (0..90).include?(latitude)
      throw(:invalid_params) unless (-180..180).include?(longitude)

      new(latitude: latitude, longitude: longitude)
    end

    # @param latitude [Numerical] geo latitude
    # @param longitude [Numerical] geo longitude
    def initialize(latitude:, longitude:)
      @latitude = latitude
      @longitude = longitude
    end

    # rubocop:disable Metrics/AbcSize
    # Calculates distance to other point
    # @param other [#latitude, #longitude]
    # @return [Numeric] distance in meters
    def distance_to(other)
      latitude_rad = to_rad(latitude)
      longitude_rad = to_rad(longitude)

      other_latitude_rad = other.latitude * RAD_PER_DEG
      other_longitude_rad = other.longitude * RAD_PER_DEG

      # Deltas, converted to rad
      delta_longitude_rad = longitude_rad - other_longitude_rad
      delta_latitude_rad = latitude_rad - other_latitude_rad

      distance_rad = Math.sin(delta_latitude_rad / 2)**2 +
                     Math.cos(latitude_rad) * Math.cos(other_latitude_rad) * Math.sin(delta_longitude_rad / 2)**2

      2 * Math.asin(Math.sqrt(distance_rad)) * EARTH_RADIUS
    end
    # rubocop:enable Metrics/AbcSize

    private

    def to_rad(val)
      val * RAD_PER_DEG
    end
  end
end
