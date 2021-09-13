require 'rails_helper'
describe "ユーザー関連機能のテスト", type: :request do
  describe "admin_userでなければユーザー管理機能は使えない" do
    before do
      @not_admin_user = FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com', admin: false)
      @other_user = FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com')

      get login_path
      expect(response).to have_http_status(:success)
      post login_path, params: { session: { email: @not_admin_user.email, password: @not_admin_user.password } }
      expect(response).to redirect_to root_path
    end

    it 'ユーザーを新たに作成できない' do
      get new_admin_user_path
      expect(response).to redirect_to root_path
      expect do
        post admin_users_path, params: { user: { name: 'ユーザーC', email: 'c@example.com', admin: true, password: 'password', password_confirmation: 'password'} }
      end.not_to change(User, :count)
      expect(response).to redirect_to root_path
    end

    it 'ユーザーを編集できない' do
      get edit_admin_user_path(@other_user)
      expect(response).to redirect_to root_path
      patch admin_user_path(@other_user), params: { user: { name: 'ユーザーC', email: 'c@example.com', admin: true} }
      expect(response).to redirect_to root_path
      expect(@other_user.reload.name).to eq @other_user.name
      expect(@other_user.reload.email).to eq @other_user.email
    end

    it 'ユーザーを削除できない' do
      expect do
        delete admin_user_path(@other_user)
      end.not_to change(User, :count)
      expect(response).to redirect_to root_path
    end
  end
end