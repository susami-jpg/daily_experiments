require 'rails_helper'
describe "ユーザー関連機能のテスト", type: :request do
  describe "admin_userでなければユーザー管理機能は使えない" do
    before do
      @not_admin_user = FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com')
      @other_user = FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com')
    end

    it 'ユーザー一覧を見れない' do

    end

    it 'ユーザー詳細を見れない' do
    
    end

    it 'ユーザーを新たに作成できない' do

    end

    it 'ユーザーを編集できない' do

    end

    it 'ユーザーを削除できない' do

    end
  end
end