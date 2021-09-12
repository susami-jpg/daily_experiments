require 'rails_helper'

describe 'ユーザー関連機能', type: :system do
  let(:admin_user) { FactoryBot.create(:user, name: 'admin', email: 'admin@example.com', admin: true) }
  let(:valid_user) {FactoryBot.build(:user, name: 'valid_user', email: 'valid@example.com')}
  let(:saved_user) {FactoryBot.create(:user, name: 'saved_user', email: 'saved@example.com')}
  let(:invalid_user) { FactoryBot.build(:user, name: '', email: '')}

 describe 'ログイン/ログアウト機能' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログインする'
    end

    describe 'ログイン機能' do
      context '登録済みの一般ユーザーの場合' do
        let(:login_user) { saved_user }

        it 'ログインし、root_pathに行き、ユーザー一覧のnav-barはない。' do
          expect(current_path).to eq root_path
          expect(page).to have_selector '.alert-success', text: 'ログインしました。'
          expect(page).to have_link 'タスク一覧'
          expect(page).to have_link '実験記録'
          expect(page).to have_link 'ログアウト'
          expect(page).not_to have_link 'ユーザー一覧'
          visit current_path
          expect(has_css?('.alert-success')).to be_falsey
        end
      end

      context '登録済みの管理者ユーザーの場合' do
        let(:login_user) { admin_user }

        it 'ログインし、root_pathに行き、ユーザー一覧のnav-barがある。' do
          expect(current_path).to eq root_path
          expect(page).to have_selector '.alert-success', text: 'ログインしました。'
          expect(page).to have_link 'タスク一覧'
          expect(page).to have_link '実験記録'
          expect(page).to have_link 'ログアウト'
          expect(page).to have_link 'ユーザー一覧'
          visit current_path
          expect(has_css?('.alert-success')).to be_falsey
        end
      end

      context '未登録のユーザーの場合' do
        let(:login_user) { valid_user }

        it 'ログイン画面を再表示する' do
          expect(page).to have_content 'ログイン'
          expect(page).to have_selector '.alert-danger', text: 'メールアドレス/パスワードの入力が正しくありません。'
          visit current_path
          expect(has_css?('.alert-danger')).to be_falsey
        end
      end
    end

    describe 'ログアウト機能' do
      context '登録済みの一般ユーザーの場合' do
        let(:login_user) { saved_user }

        it 'ログアウトするとflashメッセージが表示され、ログイン画面に行く。' do
          click_link 'ログアウト'
          expect(page).to have_selector '.alert-success', text: 'ログアウトしました。'
          visit current_path
          expect(has_css?('.alert-success')).to be_falsey
        end
      end
    end
  end


  describe 'ユーザー管理機能' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログインする'
    end

    context 'admin_userの場合' do
      let(:login_user) { admin_user }
      let(:unsaved_user) { valid_user }

      it 'ユーザー管理機能が使える。' do
        expect(current_path).to eq root_path
        expect(page).to have_selector '.alert-success', text: 'ログインしました。'
        expect(page).to have_link 'ユーザー一覧'
        click_on 'ユーザー一覧'
        expect(current_path).to eq admin_users_path

        #登録機能
        expect(page).to have_link 'ユーザー新規登録'
        click_on 'ユーザー新規登録'
        expect(current_path).to eq new_admin_user_path
        fill_in '名前', with: unsaved_user.name
        fill_in 'メールアドレス', with: unsaved_user.email
        fill_in 'パスワード', with: unsaved_user.password
        fill_in 'パスワード(確認)', with: unsaved_user.password
        expect{ click_button '登録する' }.to change{ User.count }.by(1)

        
        @user = User.find_by(name: unsaved_user.name, email: unsaved_user.email)
        expect(current_path).to eq admin_user_path(@user)
        expect(page).to have_selector '.alert-success', text: "ユーザー「#{@user.name}」を登録しました。"
        expect(page).to have_link '編集'
        expect(page).to have_link '削除'

        #編集機能
        click_link '編集'
        expect(current_path).to eq edit_admin_user_path(@user)
        expect(page).to have_content @user.name
        expect(page).to have_content @user.email
        expect(page).to have_content @user.password

        fill_in "名前", with: 'edit_user'
        click_button '登録する'

        expect(current_path).to eq admin_user_path(@user)
        expect(page).to have_content 'edit_user'
        expect(@user.reload.name).to eq 'edit_user'
        expect(page).to have_selector '.alert-success', text: "ユーザー「#{@user.reload.name}」を更新しました。"

        #削除機能
        before_delete = User.count
        page.accept_confirm do
          click_link '削除'
        end
        expect(current_path).to eq admin_users_path
        expect(page).to have_selector '.alert-success', text: "ユーザー「#{@user.name}」を削除しました。"
        expect(before_delete-1).to eq User.count
      end
    end
  end

  describe 'ユーザー登録機能' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: admin_user.email
      fill_in 'パスワード', with: admin_user.password
      click_button 'ログインする'

      visit new_admin_user_path
      fill_in '名前', with: unsaved_user.name
      fill_in 'メールアドレス', with: unsaved_user.email
      fill_in 'パスワード', with: unsaved_user.password
      fill_in 'パスワード(確認)', with: unsaved_user.password
      click_button '登録する'
    end

    context '入力されたユーザー情報が有効だった場合' do
      let(:unsaved_user) { valid_user }

      it 'ユーザー登録が成功する' do
        @valid_user = User.find_by(email: unsaved_user.email)
        expect(page).to have_selector '.alert-success', text: "ユーザー「#{@valid_user.name}」を登録しました。"
        expect(current_path).to eq admin_user_path(@valid_user)
        expect(page).to have_content @valid_user.name
        expect(page).to have_content @valid_user.email
        visit current_path
        expect(has_css?('.alert-success')).to be_falsey
      end
    end       

    context '入力されたユーザー情報が無効だった場合' do
      context '名前が無効である場合' do
        let(:unsaved_user) { invalid_user }

        it 'ユーザー登録画面に行く' do
          expect(page).to have_selector 'h1', text: 'ユーザー登録'
          #expect(page).to have_content 
        end
      end
    end
  end
end

