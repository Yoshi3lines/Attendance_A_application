class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  # beforeフィルター
    
  # paramsハッシュからuserを取得
  def set_user
    @user = User.find(params[:id])
  end
  
  # ログイン済みのユーザーなのか確認する
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてしてくだい。"
      redirect_to login_url
    end
  end
  
  # アクセスしたユーザーが現在ログインしているユーザーなのか確認する
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end
  
  # システム管理権限所有のユーザーか判定
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
  # ページを出力する前に１カ月分のデータの存在を確認とセットを実行する
  def set_one_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象となる月の日数を代入する
    # ユーザーに紐づく１か月分のレコードを検索し取得、並び替える
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    
    unless one_month.count == @attendances.count # それぞれの件数(日数)が一致するかを評価する
      ActiveRecord::Base.transaction do # トランザクションの開始
        # 繰り返し処理により、１カ月分の勤怠データを生成する
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  
  rescue ActiveRecord::RecordInvalid # トランザクションによる分岐
    flash[:danger] = "ページ情報の取得に失敗しました、再度アクセスしてください。"
    redirect_to root_url
  end
end
