class ExperimentRecordsController < ApplicationController
  def index
    @experiment_records = ExperimentRecord.all
  end

  def show
    @experiment_record = ExperimentRecord.find(params[:id])
  end

  def new
    @experiment_record = ExperimentRecord.new
  end

  def create
    @experiment_record = ExperimentRecord.new(experiment_record_params)

    if @experiment_record.save
      redirect_to @experiment_record, notice: "実験記録「#{@experiment_record.experimented_on}　#{@experiment_record.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
    @experiment_record = ExperimentRecord.find(params[:id])
  end

  def update
    @experiment_record = ExperimentRecord.find(params[:id])
    @experiment_record.update!(experiment_record_params)
    redirect_to @experiment_record, notice: "実験記録「#{@experiment_record.experimented_on}　#{@experiment_record.name}」を更新しました。"
  end

  def destroy
    @experiment_record = ExperimentRecord.find(params[:id])
    @experiment_record.destroy
    redirect_to experiment_records_url, notice: "実験記録「#{@experiment_record.experimented_on}　#{@experiment_record.name}」を削除しました。"
  end

  private

  def experiment_record_params
    params.require(:experiment_record).permit(:experimented_on, :name, :start_at, :end_at, :description)
  end
end
