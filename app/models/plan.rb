class Plan < ApplicationRecord
  has_one :subscription

  # Plan Validation
  validates :name, presence: true
end
