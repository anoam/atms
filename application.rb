# frozen_string_literal: true

# Application skeleton
class Application
  # @param atm_repository [Infrastructure::AtmRepository] ATM's collection
  # @param atm_creator [Domain::AtmCreator] domain creation service
  # @param atm_remover [Domain::AtmRemover] domain remove service
  # @param cache [Infrastructure::NearestCache] cacher for searh requests
  def initialize(atm_repository:, atm_creator:, atm_remover:, cache:)
    @atm_repository = atm_repository
    @atm_creator = atm_creator
    @atm_remover = atm_remover
    @cache = cache
  end

  # Find nearest
  # @param params [String] raw params string from console
  # @return [String]
  def nearest(params)
    latitude, longitude = catch(:invalid_params) { parse_params(params, 2) }
    return "invalid location" if longitude.nil?

    location = catch(:invalid_params) { Domain::Point.build(latitude: to_f(latitude), longitude: to_f(longitude)) }
    return "invalid location" if location.nil?

    cache.with_cache(latitude: to_f(latitude), longitude: to_f(longitude)) do
      atm_repository.nearest(location: location, count: 5).join("\n")
    end

  end

  # Add atm
  # @param params [String] raw params string from console
  # @return [String]
  def add_atm(params)
    identity, latitude, longitude = catch(:invalid_params) { parse_params(params, 3) }

    return "invalid parameters" if longitude.nil?

    new_atm = catch(:identity_not_unique) do
      new_atm = catch(:invalid_params) do
        atm_creator.create(identity: identity, latitude: to_f(latitude), longitude: to_f(longitude))
      end
      new_atm || "invalid parameters"
    end

    return "atm with identity #{identity} already exists" if new_atm.nil?

    cache.clear!

    new_atm
  end

  # Remove atm
  # @param params [String] raw params string from console
  # @return [String]
  def remove_atm(params)
    identity = catch(:invalid_params) { parse_params(params, 1).first }
    return "invalid identity" if identity.nil?

    success = catch(:unknown_atm) { atm_remover.remove(identity: identity) }

    return "entity not found" unless success

    cache.clear!

    "success"
  end

  private

  attr_reader :atm_repository, :atm_creator, :atm_remover, :cache

  def parse_params(raw_arams, expected_count)
    throw(:invalid_params) unless raw_arams.is_a?(String)

    params = raw_arams.split(";", expected_count).map(&:strip).compact

    throw(:invalid_params) if params.size < expected_count

    params
  end

  def to_f(string)
    Float(string)
  rescue ArgumentError
    throw(:invalid_params)
  end
end
