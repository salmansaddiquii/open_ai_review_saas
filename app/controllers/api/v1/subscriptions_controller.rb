class Api::V1::SubscriptionsController < Api::BaseController
  include Response
  # before_action :authorize_request

  def index
    plans = Plan.all

    if plans.any?
      json_response(true, 200, 'Available plans found successfully', plans, status: :ok)
    else
      json_error_response('No plans found', status: :not_found)
    end
  end

  def create
    if (user_id = params.dig(:subscription, :user_id)).present?
      user = User.find_by(id: user_id)

      if user && !user.subscription
        subscription = Subscription.create(subscription_params)

        if subscription
          json_response(true, 200, 'Subscription created successfully', subscription, :ok)
        else
          json_error_response('Failed to create subscription', :unprocessable_entity)
        end
      else
        json_response(false, 200, 'You already have a subscription', user&.subscription, :ok)
      end
    end
	end

  private

  def subscription_params
    params.require(:subscription).permit(:user_id, :plan_id, :start_date, :end_date)
  end
end
