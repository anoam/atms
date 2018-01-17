# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require "dispatcher"
require "domain"
require "infrastructure"
require "application"

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
# Initialize application
# @return [Dispatcher]
def init
  atm_factory = Domain::AtmFactory.new

  predefined_entities = catch(:invalid_params) do
    atm_factory.build_multiple(
      [{ identity: "Penza", latitude: 53.19, longitude: 45.01 },
       { identity: "London", latitude: 51.51, longitude: -0.085 },
       { identity: "Rostov", latitude: 47.22, longitude: 39.71 },
       { identity: "Sydney", latitude: -33.87, longitude: 151.26 },
       { identity: "Rio de Janeiro", latitude: -22.91, longitude: -43.14 },
       { identity: "Moscow", latitude: 55.75, longitude: 37.61 }]
    )
  end
  raise("Bad seeds") if predefined_entities.nil?

  atm_repository = Infrastructure::AtmRepository.new(collection: predefined_entities)

  app = Application.new(
    atm_repository: atm_repository,
    atm_creator: Domain::AtmCreator.new(factory: atm_factory, repository: atm_repository),
    atm_remover: Domain::AtmRemover.new(repository: atm_repository)
  )
  dispacther = Dispatcher.new

  dispacther.register("nearest") { |params| app.nearest(params) }
  dispacther.register("remove") { |params| app.remove_atm(params) }
  dispacther.register("add") { |params| app.add_atm(params) }

  dispacther.register("help") do
    puts <<~TEXT
      Format:
        command [arg;]
      Commands:
      - nearest:
          returns: 5 nearest atms or error description
          params: latitude; longitude
          example: nearest 51.53; 46.03
      - remove (removes ATM with given identity):
          returns: "success" or error description
          params: atm_identity
          examle: remove Moscow
      - add (adds new ATM):
          returns: "success" or error description
          params: atm_identity; latitude; longitude
          examle: add Saratov; 51.53; 46.03
    TEXT
  end

  dispacther
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
