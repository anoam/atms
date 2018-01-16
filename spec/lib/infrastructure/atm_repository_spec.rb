require "infrastructure"

RSpec.describe Infrastructure::AtmRepository do
  let(:atm1) { double(identity: "atm1") }
  let(:atm2) { double(identity: "atm2") }
  let(:atm3) { double(identity: "atm3") }

  subject { Infrastructure::AtmRepository.new(collection: [atm1, atm2, atm3]) }

  describe "#exists?" do
    it { expect(subject.exists?(identity: "atm1")).to be_truthy }
    it { expect(subject.exists?(identity: "atm2")).to be_truthy }
    it { expect(subject.exists?(identity: "atm3")).to be_truthy }
    it { expect(subject.exists?(identity: "atm4")).to be_falsey }
    it { expect(subject.exists?(identity: "random")).to be_falsey }
  end

  describe "#delete" do
    it "deletes atm1" do
      expect { subject.delete(identity: "atm1") }
          .to change{ subject.exists?(identity: "atm1") }.from(true).to(false)
    end

    it "deletes atm2" do
      expect { subject.delete(identity: "atm2") }
          .to change{ subject.exists?(identity: "atm2") }.from(true).to(false)
    end

    it "deletes atm3" do
      expect { subject.delete(identity: "atm3") }
          .to change{ subject.exists?(identity: "atm3") }.from(true).to(false)
    end
  end

  describe "#save" do
    it "adds atm" do
      expect { subject.add(double(identity: "atm42")) }
          .to change{ subject.exists?(identity: "atm42") }.from(false).to(true)
    end

    it "adds other atm" do
      expect { subject.add(double(identity: "atm9000")) }
          .to change{ subject.exists?(identity: "atm9000") }.from(false).to(true)
    end
  end

  describe "#nearest" do
    let(:target) { double(:location) }

    before do
      allow(atm1).to receive(:distance_to).with(target).and_return(100_500)
      allow(atm2).to receive(:distance_to).with(target).and_return(100)
      allow(atm3).to receive(:distance_to).with(target).and_return(9_000)
    end

    it { expect(subject.nearest(location: target, count: 1)).to eql([atm2])}
    it { expect(subject.nearest(location: target, count: 2)).to eql([atm2, atm3])}
    it { expect(subject.nearest(location: target, count: 3)).to eql([atm2, atm3, atm1])}
    it { expect(subject.nearest(location: target, count: 5)).to eql([atm2, atm3, atm1])}
    it { expect(subject.nearest(location: target, count: 10)).to eql([atm2, atm3, atm1])}
  end
end
