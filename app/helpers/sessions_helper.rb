module SessionsHelper
  
  # 引数に渡されたユーザーオブジェクトでログインする機能
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 永続的セッションを記憶する(userモデルを参照)
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 永続的セッションを破棄する
  def forget(user)
    user.forget #userモデルを参照
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # セッションと@current_userを破棄
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 一時的セッションにいるユーザーを返す
  # それ以外の場合はcookiesに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # 渡されたユーザーがログイン済みのユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end
  
  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返す
  def logged_in?
    !current_user.nil?
  end
  
  # 管理権限者、もしくは現在ログイン中のユーザーを許可します。
  # def admin_or_correct_user
  #   @user = User.find(params[:user_id]) if @user.blank?
  #   unless current_user?(@user) || current_user.admin?
  #     flash[:danger] = "編集権限がありません。"
  #     redirect_to(root_url)
  #   end
  # end
  
  # 記憶しているURL(またはデフォルトのURL)にリダイレクトさせる
  def redirect_back_or(default_url)
    redirect_to(session[:forwarding_url] || default_url)
    session.delete(:forwarding_url)
  end
  
  # アクセスしようとしたURLを記憶する
  def store_location
    session[:forwarding_url] = request.original_url if request.get? #getリクエストのみを記憶する
  end
end
