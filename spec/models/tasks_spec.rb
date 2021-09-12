require 'rails_helper'

describe 'タスクの有効性検証', type: :model do
  before do
    @user = FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com')
    @task = FactoryBot.build(:task, name: 'タスクモデルのテストを作成する。', user: @user)
  end

  context 'タスクが有効な入力である場合' do
    it '検証が通り、作成者とタスクのユーザーidが一致する' do
      expect(@task.valid?).to be_truthy
    end
    
    it '作成者とタスクのユーザーidカラムが一致する' do
      expect(@task.user_id).to eq @user.id
    end
  end

  context 'タスクの名称がnilの場合' do
    it '検証が落ちる' do
      @task.name = nil
      expect(@task.valid?).to be_falsey
    end
  end

  context 'タスクの名称が空白の場合' do
    it '検証が落ちる' do
      @task.name = "    "
      expect(@task.valid?).to be_falsey
    end
  end

  context 'タスクの名称が30文字より多い場合' do
    it '検証が落ちる' do
      @task.name = "a" * 31
      expect(@task.valid?).to be_falsey
    end
  end

  context 'タスクの名称にカンマが含まれる場合' do
    it '検証が落ちる' do
      @task.name = "abc,de"
      expect(@task.valid?).to be_falsey
    end

    it '検証が落ちる' do
      @task.name = "あいう、えお"
      expect(@task.valid?).to be_falsey
    end
  end
end