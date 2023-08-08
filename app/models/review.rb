class Review < ApplicationRecord
  belongs_to :user

  # Review Validation
  validates :content, presence: true
  validate :check_max_reviews_per_month, on: :create

  # Callback on Reviews
  after_create :generate_gpt_response

  private

  def check_max_reviews_per_month
    user = User.find_by(id: user_id)
    return unless user&.subscription

    max_reviews_per_month = user&.subscription&.plan&.max_reviews_per_month
    user_review_count = user&.reviews.where('review_date >= ?', DateTime.now.beginning_of_month).count

    if user_review_count >= max_reviews_per_month
      errors.add(:base, "You've reached the maximum number of reviews for this month")
    end
  end

  def generate_gpt_response
    begin
      client = OpenAI::Client.new(access_token: ENV['OPENAI_SECRET_KEY'])
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [{ role: "user", content: "Generate a response to the following user review:\n#{self.content}"}],
          temperature: 0.7,
        })
        review_response = response['choices'][0]['message']['content']
        return unless review_response.present?
        self.update(response_content: review_response, response_date: DateTime.now)
    rescue => e
    end
  end
end
