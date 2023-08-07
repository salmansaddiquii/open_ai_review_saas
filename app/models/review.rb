class Review < ApplicationRecord
  belongs_to :user

  # Review Validation
  validates :content, presence: true

  # Callback on Reviews
  after_create :generate_gpt_response

  private

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
