require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  include Response

  describe 'POST #login' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password') }

    it 'logs in successfully with correct credentials' do
      post :login, params: { email: 'test@example.com', password: 'password' }
      expect(response).to have_http_status(:ok)
    end

    it 'returns error for incorrect email' do
      post :login, params: { email: 'wrong@example.com', password: 'password' }
      expect(response).to have_http_status(:not_found)
    end

    it 'returns error for incorrect password' do
      post :login, params: { email: 'test@example.com', password: 'wrong_password' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST #logout' do
    let!(:user) { create(:user, auth_token: 'valid_token') }

    it 'logs out successfully' do
      
      token = JsonWebToken.encode(user_id: user.id)
      request.headers['Authorization'] = "#{token}"
      post :logout, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      expect(user.reload.auth_token).to be_nil
    end
  end
end
