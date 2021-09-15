class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).recent
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    #単純な関連付け(mergeメソッドでハッシュの中にuser_idの値を含めて登録する)
    #@task = Task.new(task_params.merge(user_id: current_user.id))
    #関連付けによって使えるtasksメソッドを利用
    #ここではtasks.newとしているがtasks.buildのほうが適切?
    @task = current_user.tasks.new(task_params)

    #すでに同名のtaskが存在する場合sqlのuniqueに引っかかるのでここで対処
    if current_user.tasks.exists?(name: @task.name)
      flash.now[:danger] = "「#{@task.name}と」同じ名前のタスクがすでに存在します。"
      render :new
    elsif @task.save
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      #出力するテンプレートのアクション名をシンボルで指定できる
      #renderでnewアクションを介さないことでユーザーが前回操作したままの値をフォーム内に引き継げる
      render :new
    end
  end

  def edit
  end

  def update
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。"
  end

  private

  def task_params
    params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
