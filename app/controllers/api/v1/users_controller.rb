class Api::V1::UsersController < Api::BaseController
	include Response
	include Auth
	include ActiveStorage::SetCurrent
	before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index forgot_password reset_password change_password]

  def index
    @users = User.all
		json_response(true, 200, 'List of all users', @users.as_json(:except => [:auth_token, :password]), status = :ok)
  end

  def show
    json_response(true, 200, 'User found successfully', @user&.attributes.merge({image_url: image_url(@user)}), status = :ok)
  end

  def create
    @user = User.new(user_params)
    if @user.save
			json_response(true, 201, 'User created successfully', @user&.attributes.merge({image_url: image_url(@user)}), status = :created)
    else
		json_error_response(@user.errors.full_messages, status = :unprocessable_entity)
    end
  end

  def update
    if @user.update(user_params)
			json_response(true, 200, 'User updated successfully', @user.attributes.merge({image_url: image_url(@user)}), status = :ok)
		else
			json_error_response(@user.errors.full_messages, status = :unprocessable_entity)
    end
  end

  def destroy
    @user.destroy
		json_response(true, 200, 'User deleted successfully', nil)
  end

	def forgot_password
		if params[:email].present?
			user = User.find_by_email(params[:email].strip)
			if user.present?
				if user&.email.present?
					user&.generate_password_reset_token
					json_response(true, 200, 'Email sent with reset_password_token successfully!', user.attributes.merge({image_url: image_url(user)}))
				else
					json_response(false, 404, 'Email not found for this user!', nil)
				end
			else
				json_response(false, 404, 'No user found for this username!', nil)
			end
		else
			json_response(false, 404, "Username can't be blank", {user: nil})
		end
	end

	def reset_password
		if params[:email].present?
      user = User.find_by_email(params[:email].strip)
      if user.present?
        token = params[:reset_password_token].present? ? params[:reset_password_token].to_s : nil
        if token == user.reset_password_token && params[:new_password].present?
          user.update(password: params[:new_password], reset_password_token: nil)
					json_response(true, 200, 'New password set successfully! Now you can login with the new password!', nil)
        else
					json_response(false, 200, 'Reset token is not correct or new password is not present!', nil)
        end
      else
				json_response(false, 400, 'User not found', nil)
      end
    else
			json_response(false, 400, "Email can't be blank", nil)
    end
	end

	def change_password
		if params[:email].present?
			user = User.find_by_email(params[:email].strip)
			if user&.valid_password?(params[:current_password])
				if params[:new_password].present?
					user.update!(password: params[:new_password])
					json_response(true, 200, "Password changed successfully", user&.attributes.merge({image_url: image_url(user)}))
				else
					json_response(false, 400, "New password can't be blank", nil)
				end
			else
				json_response(false, 400, 'User not found', nil)
			end
		else
			json_response(false, 400, "USername can't be blank", nil)
		end
	end

  private

  def find_user
    @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
  end

  def user_params
    params.permit(
      :username, :email, :password, :password_confirmation, :image
    )
  end
end
