class SessionsController < ApplicationController
  #SessionsControllerだけは未ログイン状態で使えるようにする
  skip_before_action :login_required
  
  def new
  end

  def create
    user = User.find_by(email: session_params[:email].downcase)

    if user&.authenticate(session_params[:password])
      #sessionメソッド
      session[:user_id] = user.id
      #上のコードを実行すると、ユーザーのブラウザ内の一時cookiesに暗号化済みのユーザーIDが自動で作成されます。
      #この後のページで、session[:user_id]を使用してユーザーIDを元通りに取り出すことができます。
      redirect_to root_url, notice: 'ログインしました。'
    else
      flash.now[:danger] = 'メールアドレス/パスワードの入力が正しくありません。'
      render :new
    end
  end

  def destroy
    #ユーザーに紐づく情報をセッションに入れている場合はログアウト時にそれらすべてを消したい
    #reset_sessionでセッション内の情報すべてを削除する
    #user_idのみピンポイントで消したいなら、session.delete(:user_id)
    reset_session
    redirect_to root_url, notice: 'ログアウトしました。'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
