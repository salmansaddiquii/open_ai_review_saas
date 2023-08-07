class Api::V1::SubscriptionsController < Api::BaseController
  include Response
  before_action :authorize_request

  def index
    plans = Plan.all
    if plans.present?
      json_response(true, 200, 'Available plan found successfully', plans, status = :ok)
    else
      json_error_response('plans not found', status = :not_found)
    end
  end

  def create
    if params[:subscription][:user_id].present?
      user = User.find_by(id: params[:subscription][:user_id])
      unless user&.subscription
        subscription = Subscription.create(subscription_params)
        if subscription.present?
          json_response(true, 200, 'Subscription created successfully', subscription, status = :ok)
        else
          json_error_response('Subscription not found', status = :not_found)
        end
      else
        json_response(true, 200, 'You already have Subscription', user&.subscription, status = :ok)
      end
    end
	end

  private

  def subscription_params
    params.require(:subscription).permit(:user_id, :plan_id, :start_date, :end_date)
  end
end
