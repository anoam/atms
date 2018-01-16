# frozen_string_literal: true

require "domain"
require_relative "shared_examples"

RSpec.describe Domain::AtmRemover do
  let(:atm_repository) { double(:atm_repository, exists?: true, delete: nil) }
  subject { Domain::AtmRemover.new(repository: atm_repository) }

  it "removes atm from repository" do
    expect(atm_repository).to receive(:delete).with(identity: :atm_identity)

    subject.remove(identity: :atm_identity)
  end

  context "when atm not exists" do
    before { allow(atm_repository).to receive(:exists?).with(identity: :atm_identity).and_return(false) }

    it "throws :unknown_atm" do
      expect { subject.remove(identity: :atm_identity) }.to throw_symbol(:unknown_atm)

    end
  end
end
