require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is not valid without a username" do
    user = build(:user, username: nil)
    expect(user).not_to be_valid
  end

  it "is not valid without an email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it "is not valid with a duplicate email" do
    create(:user, :with_duplicate_email)
    user = build(:user, :with_duplicate_email)
    expect(user).not_to be_valid
  end

  it "is not valid with a password less than 6 characters" do
    user = build(:user, password: "short")
    expect(user).not_to be_valid
  end
end
