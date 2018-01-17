require "infrastructure"

RSpec.describe Infrastructure::NearestCache do
  subject { Infrastructure::NearestCache.new }

  it "returns block result at first time" do
    expect(subject.with_cache(latitude: 42, longitude: 15) { "response" }).to eql("response")
  end

  it "returns cache after cached" do
    subject.with_cache(latitude: 42, longitude: 15) { "response" }
    expect(subject.with_cache(latitude: 42, longitude: 15) { "other response" }).to eql("response")
  end

  it "don't calls block when cached" do
    subject.with_cache(latitude: 42, longitude: 15) { "response" }
    expect { subject.with_cache(latitude: 42, longitude: 15) { raise("here") } }.not_to raise_error
  end

  it "calls block when was cleared" do
    subject.with_cache(latitude: 42, longitude: 15) { "response" }
    subject.clear!
    expect{ subject.with_cache(latitude: 42, longitude: 15) { raise("here") } }.to raise_error(StandardError, "here")
  end

  it "rebuilds cache after clear" do
    subject.with_cache(latitude: 42, longitude: 15) { "response" }
    subject.clear!
    subject.with_cache(latitude: 42, longitude: 15) { "new response" }
    expect(subject.with_cache(latitude: 42, longitude: 15) { "other response" }).to eql("new response")
  end
end
