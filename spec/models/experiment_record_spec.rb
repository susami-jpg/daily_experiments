require 'rails_helper'
require 'time'

describe '実験記録モデルの機能テスト', type: :model do
  before do
    @user = FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com')
    @experiment_record = FactoryBot.create(:experiment_record, experimented_on: '2021/09/06', name: '実験記録モデルのテストを作成する。', start_at: '8:00', end_at: '12:00', user: @user)
  end

  describe '実験記録の有効性検証' do
    context '実験記録が有効な入力である場合' do
      it '検証が通り、作成者と実験記録のユーザーidが一致する' do
        expect(@experiment_record.valid?).to be_truthy
      end
      
      it '作成者と実験記録のユーザーidカラムが一致する' do
        expect(@experiment_record.user_id).to eq @user.id
      end
    end

    context '実験記録の名称がnilの場合' do
      it '検証が落ちる' do
        @experiment_record.name = nil
        expect(@experiment_record.valid?).to be_falsey
      end
    end

    context '実験記録の名称が空白の場合' do
      it '検証が落ちる' do
        @experiment_record.name = "    "
        expect(@experiment_record.valid?).to be_falsey
      end
    end

    context '実験記録の名称が30文字より多い場合' do
      it '検証が落ちる' do
        @experiment_record.name = "a" * 31
        expect(@experiment_record.valid?).to be_falsey
      end
    end

    context 'あるユーザーにおいて、実験日、実験名、開始時刻が同じものがすでに登録されている場合' do
      context 'まったく同じレコードの場合' do
        it '検証が落ちる' do
          duplicate_experiment_record = @experiment_record.dup
          @experiment_record.save
          expect(duplicate_experiment_record.valid?).to be_falsey
        end
      end

      context 'end_atだけ異なる場合' do
        it '検証が落ちる' do
          duplicate_experiment_record = @experiment_record.dup
          duplicate_experiment_record.end_at = nil
          @experiment_record.save
          expect(duplicate_experiment_record.valid?).to be_falsey
        end
      end
    end
  end

  describe 'timeに関する機能のテスト' do
    context 'start_atが入力されない場合' do
      it '実験日がstart_atの時刻(詳細な時刻は00:00:00)となる' do
        @experiment_record.start_at = ""
        @experiment_record.save

        saved_experiment_record = ExperimentRecord.find_by(experimented_on: @experiment_record.experimented_on, name: @experiment_record.name, user: @experiment_record.user_id)
        expect(Time.zone.parse(saved_experiment_record.start_at).strftime("%Y-%m-%d")).to eq saved_experiment_record.experimented_on
      end
    end

    context 'end_atが入力されない場合' do
      it '実験記録の作成時刻がend_atの時刻となる' do
        @experiment_record.end_at = ""
        @experiment_record.save

        saved_experiment_record = ExperimentRecord.find_by(experimented_on: @experiment_record.experimented_on, name: @experiment_record.name, user: @experiment_record.user_id)
        expect(saved_experiment_record.end_at).to eq saved_experiment_record.created_at.strftime("%Y-%m-%d %H:%M")
      end
    end

    context 'start_atの年月日が記載されない場合' do
      it '実験日がstart_atの年月日となる' do
        @experiment_record.save

        saved_experiment_record = ExperimentRecord.find_by(experimented_on: @experiment_record.experimented_on, name: @experiment_record.name, user: @experiment_record.user_id)
        expect(Time.zone.parse(saved_experiment_record.start_at).strftime("%Y-%m-%d")).to eq saved_experiment_record.experimented_on
      end
    end

    context 'end_atの年月日が記載されない場合' do
      it '実験日がend_atの年月日となる' do
        @experiment_record.save

        saved_experiment_record = ExperimentRecord.find_by(experimented_on: @experiment_record.experimented_on, name: @experiment_record.name, user: @experiment_record.user_id)
        expect(Time.zone.parse(saved_experiment_record.end_at).strftime("%Y-%m-%d")).to eq saved_experiment_record.experimented_on
      end
    end

    context 'start_atの年月日が記載されている場合' do
      it '登録された年月日(/区切り)がstart_atの年月日となる' do
        s_time = '2021/06/30 12:00'
        @experiment_record.start_at = s_time
        @experiment_record.save

        saved_experiment_record = ExperimentRecord.find_by(experimented_on: @experiment_record.experimented_on, name: @experiment_record.name, user: @experiment_record.user_id)
        expect(Time.zone.parse(saved_experiment_record.start_at)).to eq Time.zone.parse(s_time)
      end

      it '登録された年月日(-区切り)がstart_atの年月日となる' do
        s_time = '2021-06-30 12:00'
        @experiment_record.start_at = s_time
        @experiment_record.save

        saved_experiment_record = ExperimentRecord.find_by(experimented_on: @experiment_record.experimented_on, name: @experiment_record.name, user: @experiment_record.user_id)
        expect(Time.zone.parse(saved_experiment_record.start_at)).to eq Time.zone.parse(s_time)
      end
    end

    context 'end_atの年月日が記載されない場合' do
      it '登録された年月日(/区切り)がend_atの年月日となる' do
        e_time = '2021/09/08 12:00'
        @experiment_record.end_at = e_time
        @experiment_record.save

        saved_experiment_record = ExperimentRecord.find_by(experimented_on: @experiment_record.experimented_on, name: @experiment_record.name, user: @experiment_record.user_id)
        expect(Time.zone.parse(saved_experiment_record.end_at)).to eq Time.zone.parse(e_time)
      end

      it '登録された年月日(-区切り)がend_atの年月日となる' do
        e_time = '2021-09-08 12:00'
        @experiment_record.end_at = e_time
        @experiment_record.save

        saved_experiment_record = ExperimentRecord.find_by(experimented_on: @experiment_record.experimented_on, name: @experiment_record.name, user: @experiment_record.user_id)
        expect(Time.zone.parse(saved_experiment_record.end_at)).to eq Time.zone.parse(e_time)
      end
    end

    context 'start_atとend_atが登録される場合' do
      context 'start_at <= end_atの場合' do
        it 'required_timeが計算される' do
          times = [['8:00','10:00'], ['2021/08/30 8:30', '2021/09/01 13:45'], ['2021/06/30 12:12', '']]
          for s, e in times
            @experiment_record.start_at = s
            @experiment_record.end_at = e
            @experiment_record.save

            saved_experiment_record = ExperimentRecord.find_by(experimented_on: @experiment_record.experimented_on, name: @experiment_record.name, user: @experiment_record.user_id)
            saved_experiment_record.calc_required_time

            rt = (Time.zone.parse(saved_experiment_record.end_at) - Time.zone.parse(saved_experiment_record.start_at))/60
            rt = rt.divmod(60)[0].to_s + '時間' + rt.divmod(60)[1].to_int.to_s + '分'

            expect(rt).to eq saved_experiment_record.required_time
          end
        end
      end

      context 'start_at > end_atの場合' do
        it 'required_timeが計算されない' do
          times = [['12:00', '10:00'], ['2021/08/30 8:30', '2021/08/01 13:45']]
          for s, e in times
            @experiment_record.start_at = s
            @experiment_record.end_at = e
            @experiment_record.save

            saved_experiment_record = ExperimentRecord.find_by(experimented_on: @experiment_record.experimented_on, name: @experiment_record.name, user: @experiment_record.user_id)
            saved_experiment_record.calc_required_time
            
            expect(saved_experiment_record.required_time).to eq nil
          end
        end
      end
    end
  end
end 