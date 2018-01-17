
require_relative "../dispatcher"

RSpec.describe Dispatcher do
  let(:command_result) { double("something") }

  subject { Dispatcher.new }
  before do
    subject.register("first_command") { |arguments| { command: "first_command", arguments: arguments } }
    subject.register("second_command") { |arguments| { command: "second_command", arguments: arguments } }
  end

  it "runs command" do
    expect(subject.run("first_command")[:command]).to eql("first_command")
  end

  it "runs another command" do
    expect(subject.run("second_command")[:command]).to eql("second_command")
  end

  it "strips spaces" do
    expect(subject.run(" first_command ")[:command]).to eql("first_command")
  end

  it "returns error on unknown command" do
    expect(subject.run("unknown_command")).to eql("Command is unknown")
  end

  it "don't sends arguments if wasn't given" do
    expect(subject.run(" first_command ")[:arguments]).to be_nil
  end

  it "sends arguments" do
    expect(subject.run("second_command some_arguments here")[:arguments]).to eql("some_arguments here")
  end

  it "strip arguments' spaces" do
    expect(subject.run(" second_command    some_arguments here  ")[:arguments]).to eql("some_arguments here")
  end

end