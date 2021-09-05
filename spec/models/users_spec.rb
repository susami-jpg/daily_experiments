require 'rails_helper'

describe 'ユーザーの有効性検証', type: :model do
  before(:each) do
    #ユーザのセット
    @user = FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com')
  end

  context 'ユーザーが有効である場合' do
    it '検証が通る' do
      expect(@user.valid?).to be_truthy
    end
  end
  
  context 'ユーザー名がない場合' do
    context 'ユーザー名がnilの場合' do
      it '検証が落ちる' do
        @user.name = nil
        expect(@user.valid?).to be_falsey
      end
    end
    
    context 'ユーザー名が空白の場合' do
      it '検証が落ちる' do
        @user.name = "     "
        expect(@user.valid?).to be_falsey
      end
    end
  end

  context 'ユーザーのemailがない場合' do
    context 'ユーザーのemailがnilの場合' do
      it '検証が落ちる' do
        @user.email = nil
        expect(@user.valid?).to be_falsey
      end
    end
    
    context 'ユーザーのemailが空白の場合' do
      it '検証が落ちる' do
        @user.email = "     "
        expect(@user.valid?).to be_falsey
      end
    end
  end

  context 'ユーザーの名前が51以上の場合' do
    it '検証が落ちる' do
      @user.name = "a" * 51
      expect(@user.valid?).to be_falsey
    end
  end

  context 'ユーザーのemailの長さが256以上の場合' do
    it '検証が落ちる' do
      @user.email = "a" * 243 + "a@example.com"
      expect(@user.valid?).to be_falsey
    end
  end

  context 'ユーザーのメールフォーマットが正しくない場合' do
    it 'ユーザーのメールフォーマットが正しくなければ検証で落ちる' do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user.valid?).to be_falsey
        #puts invalid_address + "がメールフォーマットとして不適です。" unless @user.valid?
      end
    end                      
  end

  context 'ユーザーのメールフォーマットが正しい場合' do
    it 'ユーザーのメールフォーマットが正しければ検証が通る' do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user.valid?).to be_truthy
        puts valid_address unless @user.valid?
      end
    end                      
  end

  context 'すでに同じemailが登録されている場合' do
    it '同じemailアドレスをもつユーザーは登録できない' do
      duplicate_user = @user.dup
      duplicate_user.email = @user.email.upcase
      @user.save
      expect(duplicate_user.valid?).to be_falsey
    end
  end

  context '大文字小文字の混じったメールアドレスが登録される場合' do
    it '全て小文字に変換して登録される' do
      mixed_case_email = "Foo@ExAMPle.CoM"
      @user.email = mixed_case_email
      @user.save
      expect(mixed_case_email.downcase).to eq @user.reload.email
    end
  end

  context 'パスワードが有効でない場合' do
    context 'パスワードが空白の場合' do
      it '検証が落ちる' do
        @user.password = @user.password_confirmation = " " * 6
        expect(@user.valid?).to be_falsey
      end
    end

    context 'パスワードが6文字未満の場合' do
      it '検証が落ちる' do
        @user.password = @user.password_confirmation = "a" * 5
        expect(@user.valid?).to be_falsey
      end
    end
  end
end