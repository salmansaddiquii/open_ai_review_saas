require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:user) { create(:user) }
  let(:plan) { create(:plan) }

  it "is valid with valid attributes" do
    subscription = build(:subscription, user: user, plan: plan)
    expect(subscription).to be_valid
  end

  it "is not valid without a user" do
    subscription = build(:subscription, :without_user, plan: plan)
    expect(subscription).not_to be_valid
  end

  it "is not valid without a plan" do
    subscription = build(:subscription, :without_plan, user: user)
    expect(subscription).not_to be_valid
  end
end
