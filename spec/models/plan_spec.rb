require 'rails_helper'

RSpec.describe Plan, type: :model do
  it "is valid with valid attributes" do
    plan = build(:plan)
    expect(plan).to be_valid
  end

  it "is not valid without a name" do
    plan = build(:plan, name: nil, max_reviews_per_month: nil)
    expect(plan).not_to be_valid
  end

  it "is valid with the 'Trail Plan' name" do
    plan = build(:plan, :trail)
    expect(plan).to be_valid
    expect(plan.max_reviews_per_month).to eq(3)
  end

  it "is valid with the 'Basic Plan' name" do
    plan = build(:plan, :basic)
    expect(plan).to be_valid
    expect(plan.max_reviews_per_month).to eq(20)
  end

  it "is valid with the 'Pro Plan' name" do
    plan = build(:plan, :pro)
    expect(plan).to be_valid
    expect(plan.max_reviews_per_month).to eq(100)
  end
end
