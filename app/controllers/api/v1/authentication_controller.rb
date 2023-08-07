class Api::V1::AuthenticationController < Api::BaseController
  include Response
  include Auth
  include ActiveStorage::SetCurrent
	before_action :authorize_request, except: :login

  def login
    @user = User.find_by_email(params[:email])
    if @user.present?
      authentication(@user)
    else
      json_error_response('User not found', :not_found)
    end
  end

  def logout
    if params[:id].present?
      user = User.find(params[:id])
      if user.present?
        user.update!(auth_token: nil, updated_at: Time.now)
        json_response(true, 200, 'User logged out successfully', { user: nil })
      else
        json_error_response(user.errors.full_messages, :unauthorized)
      end
    else
      json_error_response('NO user found with this given id', :not_found)
    end
  end

  private

  def login_params
    params.permit(:username, :password)
  end

  def authentication(user)
    if user&.valid_password?(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      user.update!(auth_token: token) if token.present?
      json_response(true, 200, 'User logged in successfully', user.attributes.merge({image_url: image_url(user)}))
    else
      json_error_response('unauthorized', :unauthorized)
    end
  end
end
