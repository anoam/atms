require "domain"
require_relative "shared_examples"

RSpec.describe Domain::Atm do
  let(:point_stub1) { double(latitude: 53.19, longitude:  45.01, distance_to: 42) }
  let(:point_stub2) { double(latitude: 51.51, longitude:  -0.085, distance_to: 9000) }

  # ensure interface
  it_behaves_like("point") { let(:point) { point_stub1 } }
  it_behaves_like("point") { let(:point) { point_stub2 } }

  let(:atm1) { Domain::Atm.new(identity: "SuperATM", point: point_stub1) }
  let(:atm2) { Domain::Atm.new(identity: "AnotherATM", point: point_stub2) }

  describe "#coordinates" do
    it { expect(atm1.latitude).to eq(53.19) }
    it { expect(atm1.longitude).to eq(45.01) }

    it { expect(atm2.latitude).to eq(51.51) }
    it { expect(atm2.longitude).to eq(-0.085) }
  end

  describe "#identity" do
    it {expect(atm1.identity).to eq("SuperATM")}
    it {expect(atm2.identity).to eq("AnotherATM")}
  end

  describe "#to_s" do
    it { expect(atm1.to_s).to eq("SuperATM (53.19; 45.01)") }
    it { expect(atm2.to_s).to eq("AnotherATM (51.51; -0.085)") }
  end

  describe "distance_to" do
    let(:current_point) { double(:point) }

    it "check distance to atm1" do
      expect(point_stub1).to receive(:distance_to).with(current_point)
      distance = atm1.distance_to(current_point)

      expect(distance).to eql(42)
    end

    it "check distance to atm2" do
      expect(point_stub2).to receive(:distance_to).with(current_point)
      distance = atm2.distance_to(current_point)

      expect(distance).to eql(9000)
    end
  end
end
