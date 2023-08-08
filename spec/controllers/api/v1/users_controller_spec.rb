require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'authenticated requests' do
    let(:user) { create(:user) }

    before do
      token = JsonWebToken.encode(user_id: user.id)
      request.headers['Authorization'] = "#{token}"
    end

    it 'should get index' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'should show user' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
    end

    it 'should update user' do
      put :update, params: { id: user.id, user: { username: 'new_username' } }
      expect(response).to have_http_status(:ok)
    end

    it 'should destroy user' do
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(:ok)
    end
  end
end
