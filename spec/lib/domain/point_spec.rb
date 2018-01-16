require "domain"
require_relative "shared_examples"

RSpec.describe Domain::Point do
  describe "instance methods" do
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

  describe ".build" do
    subject { Domain::Point }

    context "when params valid" do
      it "builds point" do
        built = subject.build(latitude: 55.75, longitude: 37.61)
        expect(built).to be_a(Domain::Point)
        expect(built.latitude).to eql(55.75)
        expect(built.longitude).to eql(37.61)
      end
    end

    context "when params invalid" do

      it "throws on non-numeric latitude" do
        expect { subject.build(latitude: "invalid", longitude: 37.61) }.to throw_symbol(:invalid_params)
        expect { subject.build(latitude: nil, longitude: 37.61) }.to throw_symbol(:invalid_params)
      end

      it "throws on non-numeric longitude" do
        expect { subject.build(latitude: 55.75, longitude: "invalid") }.to throw_symbol(:invalid_params)
        expect { subject.build(latitude: 55.75, longitude: nil) }.to throw_symbol(:invalid_params)
      end

      it "throws on invalid latitude" do
        expect { subject.build(latitude: -91, longitude: 37.61) }.to throw_symbol(:invalid_params)
        expect { subject.build(latitude: 90.01, longitude: 37.61) }.to throw_symbol(:invalid_params)
      end

      it "throws on invalid longitude" do
        expect { subject.build(latitude: 55.75, longitude: -181) }.to throw_symbol(:invalid_params)
        expect { subject.build(latitude: 55.75, longitude: 180.1) }.to throw_symbol(:invalid_params)
      end

    end
  end

end