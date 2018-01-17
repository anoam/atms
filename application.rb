class Application

  def initialize(atm_repository:, atm_creator:, atm_remover:)
    @atm_repository = atm_repository
    @atm_creator = atm_creator
    @atm_remover = atm_remover
  end

  def nearest(params)
    latitude, longitude = catch(:invalid_params) { parse_params(params, 2) }
    return "invalid location" if longitude.nil?

    location = catch(:invalid_params) { Domain::Point.build(latitude: to_f(latitude), longitude: to_f(longitude)) }
    return "invalid location" if location.nil?

    atm_repository.nearest(location: location, count: 5).join("\n")
  end

  def add_atm(params)
    identity, latitude, longitude = catch(:invalid_params) { parse_params(params, 3) }

    return "invalid parameters" if longitude.nil?

    new_atm = catch(:identity_not_unique) do
      new_atm = catch(:invalid_params) do
        atm_creator.create(identity: identity, latitude: to_f(latitude), longitude: to_f(longitude))
      end
      new_atm || "invalid parameters"
    end

    new_atm || "atm with identity #{identity} already exists"
  end

  def remove_atm(params)
    identity = catch(:invalid_params) { parse_params(params, 1).first }
    return "invalid identity" if identity.nil?

    success = catch(:unknown_atm) { atm_remover.remove(identity: identity) }

    return "entity not found" unless success

    "success"
  end

  private

  attr_reader :atm_repository, :atm_creator, :atm_remover

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