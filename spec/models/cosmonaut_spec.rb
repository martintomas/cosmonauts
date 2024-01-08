require 'rails_helper'

RSpec.describe Cosmonaut, type: :model do
  subject { build(:cosmonaut) }

  it { is_expected.to be_valid }

  it "should not be valid without first_name" do
    subject.first_name = nil
    expect(subject).to have(1).errors_on(:first_name)
  end

  it "should not be valid without last_name" do
    subject.last_name = nil
    expect(subject).to have(1).errors_on(:last_name)
  end

  it "should not be valid without physical_condition" do
    subject.physical_condition = nil
    expect(subject).to have(1).errors_on(:physical_condition)
  end

  it "should not be valid without mental_endurance" do
    subject.mental_endurance = nil
    expect(subject).to have(1).errors_on(:mental_endurance)
  end

  it "should not be valid with invalid physical_condition" do
    subject.physical_condition = "invalid"
    expect(subject).to have(1).errors_on(:physical_condition)
  end

  it "should not be valid with invalid mental_endurance" do
    subject.mental_endurance = "invalid"
    expect(subject).to have(1).errors_on(:mental_endurance)
  end
end
