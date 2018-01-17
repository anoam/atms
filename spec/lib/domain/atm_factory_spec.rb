require "domain"
require_relative "shared_examples"

RSpec.describe Domain::AtmFactory do
  subject { Domain::AtmFactory.new }
  # ensure interface
  it_behaves_like("atm_factory") { let(:factory) { subject } }

  describe "#build" do

    it "builds ATM" do
      expect(subject.build(identity: "CoolATM1", latitude: 53.19, longitude: 45.01)).to be_a(Domain::Atm)
    end

    it "builds ATM with given data" do
      atm = subject.build(identity: "CoolATM1", latitude: 53.19, longitude: 45.01)

      expect(atm.identity).to eql("CoolATM1")
      expect(atm.latitude).to eql(53.19)
      expect(atm.longitude).to eql(45.01)
    end

    it "builds another ATM with given data" do
      atm = subject.build(identity: "AnotherCoolATM2", latitude: 51.51, longitude: -0.085)

      expect(atm.identity).to eql("AnotherCoolATM2")
      expect(atm.latitude).to eql(51.51)
      expect(atm.longitude).to eql(-0.085)
    end

    it "fails on invalid identity" do
      expect { subject.build({identity: "", latitude: 53.19, longitude: 45.01}) }.to throw_symbol(:invalid_params)
      expect { subject.build({identity: nil, latitude: 53.19, longitude: 45.01}) }.to throw_symbol(:invalid_params)
    end

    context "when coordinates are invalid" do
      let(:point_factory) { double(:point_factory) }
      before { allow(point_factory).to receive(:build) { throw(:invalid_params) } }
      subject { Domain::AtmFactory.new(point_factory: point_factory) }

      it "throws" do
        expect { subject.build({identity: "CoolATM1", latitude: "ivalid", longitude: 45.01}) }
          .to throw_symbol(:invalid_params)
      end

    end
  end

  describe "#build_multiple" do
    it "build array of ATMs" do
      collection = subject.build_multiple([{identity: "CoolATM1", latitude: 53.19, longitude: 45.01}])

      expect(collection).to be_a(Array)
      expect(collection.size).to eql(1)
    end

    it "returns single ATM in collcection" do
      collection = subject.build_multiple([{identity: "CoolATM1", latitude: 53.19, longitude: 45.01}])

      atm = collection.first
      expect(atm).to be_a(Domain::Atm)
      expect(atm.identity).to eql("CoolATM1")
      expect(atm.latitude).to eql(53.19)
      expect(atm.longitude).to eql(45.01)
    end

    it "returns two ATMs in collcection" do
      collection = subject.build_multiple(
        [{ identity: "CoolATM1", latitude: 53.19, longitude: 45.01 },
         { identity: "AnotherCoolATM2", latitude: 51.51, longitude: -0.085 }]
      )

      expect(collection.size).to eql(2)

      atm1 = collection.first
      expect(atm1).to be_a(Domain::Atm)
      expect(atm1.identity).to eql("CoolATM1")
      expect(atm1.latitude).to eql(53.19)
      expect(atm1.longitude).to eql(45.01)

      atm2 = collection.last
      expect(atm2).to be_a(Domain::Atm)
      expect(atm2.identity).to eql("AnotherCoolATM2")
      expect(atm2.latitude).to eql(51.51)
      expect(atm2.longitude).to eql(-0.085)
    end

    it "fails on invalid params" do
      expect { subject.build_multiple(:invalid_stuff) }.to throw_symbol(:invalid_params)
      expect { subject.build_multiple([{identity: "", latitude: 53.19, longitude: 45.01}]) }.to throw_symbol(:invalid_params)
      expect { subject.build_multiple([{identity: nil, latitude: 53.19, longitude: 45.01}]) }.to throw_symbol(:invalid_params)
    end

    context "when coordinates are invalid" do
      let(:point_factory) { double(:point_factory) }
      before { allow(point_factory).to receive(:build) { throw(:invalid_params) } }
      subject { Domain::AtmFactory.new(point_factory: point_factory) }

      it "fails" do
        expect{ subject.build_multiple([{identity: "CoolATM1", latitude: "ivalid", longitude: 45.01}]) }.to throw_symbol(:invalid_params)
      end
    end

  end
end
