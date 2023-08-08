require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { create(:user) }
  let(:plan) { create(:plan, :trail) }
  let(:subscription) { create(:subscription, user: user, plan: plan) }

  it "is valid with valid attributes" do
    review = build(:review, user: user)
    expect(review).to be_valid
  end

  it "is not valid without content" do
    review = build(:review, user: user, content: nil)
    expect(review).not_to be_valid
  end

  it "is not valid when exceeding max_reviews_per_month" do
    subscription
    create_list(:review, plan.max_reviews_per_month, user: user, review_date: DateTime.now.beginning_of_month)
    review = build(:review, :with_custom_content, user: user)
    expect(review).not_to be_valid
  end

  it "generates GPT response after create" do
    review = build(:review, user: user)
    expect(review).to receive(:generate_gpt_response)
    review.save
  end
end
