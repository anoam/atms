require "domain"
require_relative "shared_examples"

RSpec.describe Domain::Point do
  let(:penza) { Domain::Point.new(latitude: 53.19, longitude: 45.01) }
  let(:london) { Domain::Point.new(latitude: 51.51, longitude: -0.085) }

  # ensure interface
  it_behaves_like("point") { let(:point) { penza } }
  it_behaves_like("point") { let(:point) { london } }

  describe "#coordinates" do
    it { expect(penza.latitude).to eq(53.19) }
    it { expect(penza.longitude).to eq(45.01) }

    it { expect(london.latitude).to eq(51.51) }
    it { expect(london.longitude).to eq(-0.085) }
  end

  describe "#distance_to" do
    let(:moscow) { Domain::Point.new(latitude: 55.75, longitude: 37.61) }

    it { expect(penza.distance_to(london).round).to eql(3_017_602) }
    it { expect(london.distance_to(penza).round).to eql(3_017_602) }

    it { expect(penza.distance_to(moscow).round).to eql(556_069) }
    it { expect(london.distance_to(moscow).round).to eql(2_497_344) }
  end
end