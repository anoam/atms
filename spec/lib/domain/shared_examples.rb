RSpec.shared_examples "point" do
  it { expect(point).to respond_to(:latitude) }
  it { expect(point).to respond_to(:longitude) }
  it { expect(point).to respond_to(:distance_to) }
end
