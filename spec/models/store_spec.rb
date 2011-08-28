require 'spec_helper'

describe Store do
  it "validates presence of require attributes" do
    subject.save
    subject.errors[:name].should_not be_nil
    subject.errors[:address].should_not be_nil
    subject.errors[:latitude].should_not be_nil
    subject.errors[:longitude].should_not be_nil
  end
end
