
require_relative '../init'

RSpec.describe "application work" do
  subject { init }

  it "finds nearest ATMs for Saratov" do
    expect(subject.run("nearest 51.53; 46.03")).to eql(<<~text.strip)
      Penza (53.19; 45.01)
      Rostov (47.22; 39.71)
      Moscow (55.75; 37.61)
      London (51.51; -0.085)
      Rio de Janeiro (-22.91; -43.14)
    text
  end

  it "finds nearest ATMs for Shanghai" do
    expect(subject.run("nearest 31.23; 121.46")).to eql(<<~text.strip)
      Penza (53.19; 45.01)
      Moscow (55.75; 37.61)
      Rostov (47.22; 39.71)
      Sydney (-33.87; 151.26)
      London (51.51; -0.085)
    text
  end

  it "finds nearest ATMs for Melbourne" do
    expect(subject.run("nearest -37.8; 144.95")).to eql(<<~text.strip)
      Sydney (-33.87; 151.26)
      Rio de Janeiro (-22.91; -43.14)
      Penza (53.19; 45.01)
      Rostov (47.22; 39.71)
      Moscow (55.75; 37.61)
    text
  end

  it "Adds ATM" do
    expect(subject.run("add Saratov; 51.53; 46.03").to_s).to eql("Saratov (51.53; 46.03)")
  end

  it "Adds only one atm with given identity" do
    subject.run("add Saratov; 51.53; 46.03")
    expect(subject.run("add Saratov; 51.53; 46.03").to_s).to eql("atm with identity Saratov already exists")
  end

  it "Makes new ATM available for search" do
    subject.run("add Saratov; 51.53; 46.03")

    expect(subject.run("nearest 51.53; 46.03")).to eql(<<~text.strip)
      Saratov (51.53; 46.03)
      Penza (53.19; 45.01)
      Rostov (47.22; 39.71)
      Moscow (55.75; 37.61)
      London (51.51; -0.085)
    text
  end

  it "removes ATM" do
    expect(subject.run("remove Moscow")).to eql("success")
  end

  it "removed atm isn't acailable in search" do
    subject.run("remove Moscow")
    expect(subject.run("nearest 31.23; 121.46")).to eql(<<~text.strip)
      Penza (53.19; 45.01)
      Rostov (47.22; 39.71)
      Sydney (-33.87; 151.26)
      London (51.51; -0.085)
      Rio de Janeiro (-22.91; -43.14)
    text
  end

  it "fails on invalid commands" do
    expect(subject.run("nearest")).to eql("invalid location")
    expect(subject.run("nearest ; 144.95")).to eql("invalid location")
    expect(subject.run("nearest 399; 800")).to eql("invalid location")
    expect(subject.run("add")).to eql("invalid parameters")
    expect(subject.run("add asd")).to eql("invalid parameters")
    expect(subject.run("add asd;")).to eql("invalid parameters")
    expect(subject.run("add asd; 988; 5368")).to eql("invalid parameters")
    expect(subject.run("remove")).to eql("invalid identity")
    expect(subject.run("remove foo")).to eql("entity not found")
  end


end