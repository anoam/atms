# frozen_string_literal: true

# Contains domain logic
module Domain
  autoload :Atm, "domain/atm"
  autoload :Point, "domain/point"
  autoload :AtmFactory, "domain/atm_factory"
  autoload :AtmCreator, "domain/atm_creator"
  autoload :AtmRemover, "domain/atm_remover"
end
