# frozen_string_literal: true

require "domain"
require_relative "shared_examples"

RSpec.describe Domain::AtmCreator do
  let(:fake_atm) { double(:atm) }
  let(:atm_factory) { double(:atm_factory, build: fake_atm) }
  # ensure interface
  it_behaves_like("atm_factory") { let(:factory) { atm_factory } }

  let(:atm_repository) { double(:atm_repository, save: nil, exists?: false) }


  subject { Domain::AtmCreator.new(factory: atm_factory, repository: atm_repository) }

  it "builds new atm with given params" do
    expect(atm_factory).to receive(:build).with(identity: "CoolATM1", latitude: 53.19, longitude: 45.01)
    subject.create(identity: "CoolATM1", latitude: 53.19, longitude: 45.01)
  end

  it "saves atm to repository" do
    expect(atm_repository).to receive(:save).with(fake_atm)
    subject.create(identity: "CoolATM1", latitude: 53.19, longitude: 45.01)
  end

  it "returns created atm" do
    expect(subject.create(identity: "CoolATM1", latitude: 53.19, longitude: 45.01)).to be(fake_atm)
  end

  context "when params are invalid" do
    before { allow(atm_factory).to receive(:build) { throw(:invalid_params) }}

    it "throws" do
      expect { subject.create(identity: "CoolATM1", latitude: 53.19, longitude: 45.01) }.to throw_symbol(:invalid_params)
    end
  end

  context "when identity not unqie" do
    before { allow(atm_repository).to receive(:exists?).with(identity: "CoolATM1").and_return(true) }

    it "throws :identity_not_unique" do
      expect { subject.create(identity: "CoolATM1", latitude: 53.19, longitude: 45.01) }.to throw_symbol(:identity_not_unique)
    end
  end
end
