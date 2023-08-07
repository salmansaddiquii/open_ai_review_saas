include Response

class Api::V1::ReviewsController < Api::BaseController
  before_action :authorize_request

  def index
    user = User.find_by(id: params[:review][:user_id])
    if user
      reviews = user&.reviews
      if reviews.present?
        json_response(true, 200, 'User review found successfully', reviews, status = :ok)
      else
        json_error_response('Something went wrong', status = :unprocessable_entity)
      end
    else
      json_error_response('User not found', status = :not_found)
    end
  end

  def create
    # need to check subscription before review
    if params[:review][:user_id].present?
      review = Review.new(review_params)
      review.review_date = DateTime.now
      if review.save
        json_response(true, 201, 'Review created successfully', review, status = :created)
      else
        json_error_response(review.errors.full_messages, status = :unprocessable_entity)
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :user_id, :review_date, :response_content, :response_date)
  end
end
