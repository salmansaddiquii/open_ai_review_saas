include Response

class Api::V1::ReviewsController < Api::BaseController
  before_action :authorize_request

  def index
    user = User.find_by(id: params.dig(:review, :user_id))
    if user
      reviews = user.reviews

      if reviews.any?
        json_response(true, 200, 'User reviews found successfully', reviews, status: :ok)
      else
        json_error_response('No reviews found for this user', status: :unprocessable_entity)
      end
    else
      json_error_response('User not found', status: :not_found)
    end
  end

  def create
    user = User.find_by(id: params.dig(:review, :user_id))
    if user&.subscription
      max_reviews_per_month = user&.subscription&.plan&.max_reviews_per_month
      user_review_count = user&.reviews&.count

      if max_reviews_per_month > user_review_count
        review = Review.new(review_params.merge(review_date: DateTime.now))

        if review.save
          json_response(true, 201, 'Review created successfully', review, status: :created)
        else
          json_error_response(review.errors.full_messages, status: :unprocessable_entity)
        end
      else
        json_response(true, 200, 'Your monthly limit has been reached', nil, status: :ok)
      end
    else
      json_response(true, 200, 'You must subscribe first', nil, status: :ok)
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :user_id, :review_date, :response_content, :response_date)
  end
end
