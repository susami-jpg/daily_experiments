class ExperimentRecordsController < ApplicationController
  before_action :set_experiment_record, only: [:show, :edit, :update, :destroy]
  def index
    @experiment_records = current_user.experiment_records.order(experimented_on: :asc)
  end

  def show
  end

  def new
    @experiment_record = ExperimentRecord.new
  end

  def create
    @experiment_record = current_user.experiment_records.new(experiment_record_params)

    if @experiment_record.save
      redirect_to @experiment_record, notice: "実験記録「#{@experiment_record.experimented_on}　#{@experiment_record.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    @experiment_record.update!(experiment_record_params)
    redirect_to @experiment_record, notice: "実験記録「#{@experiment_record.experimented_on}　#{@experiment_record.name}」を更新しました。"
  end

  def destroy
    @experiment_record.destroy
    redirect_to experiment_records_url, notice: "実験記録「#{@experiment_record.experimented_on}　#{@experiment_record.name}」を削除しました。"
  end

  private

  def experiment_record_params
    params.require(:experiment_record).permit(:experimented_on, :name, :start_at, :end_at, :description)
  end

  def set_experiment_record
    @experiment_record = current_user.experiment_records.find(params[:id])
  end
end
