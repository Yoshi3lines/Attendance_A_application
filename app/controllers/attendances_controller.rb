class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month,]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month
  before_action :admin_not
  before_action :correct_not, only: [:show, :edit_one_month]
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  # 残業申請モーダル
  def edit_overtime_request
    @user = User.find(params[:id])
    @attendance = Attendance.find(params[:id])
    @superior = User.where(superior: true).where.not(id: current_user.id)
  end
  
  def update_overtime_request
    @user = User.find(params[:id])
    @attendance = Attendance.find(params[:id])
    if @attendance.update_attributes(overtime_params)
      flash[:success] = "残業申請を受け付けました"
      redirect_to user_url(@user)
    end
  end
  
  # 残業申請お知らせモーダル　
  def edit_overtime_notice
    @users = User.joins(:attendances).group("users.id").where(attendances: {indicater_reply: "申請中"})
    @attendances = Attendance.where.not(overtime_finished_at: nil).order("worked_on ASC")
  end
  
  
  private
    # 勤怠編集、元の状態はstarted_atとfinished_atとnoteのみで、あとは追加項目
    def attendances_params
      params.require(:user).permit(attendances: [:worked_on, :started_at, :finished_at, :started_edit_at, :finished_edit_at, :tomorrow_edit, :note, :indicater_check_edit, :indicater_reply_edit])[:attendances]
    end
    
    
    # 残業申請モーダル情報
    def overtime_params
      params.require(:attendance).permit(:overtime_finished_at, :tomorrow, :overtime_work, :indicater_check, :indicater_reply)
    end
    
    # 残業申請お知らせモーダル
    def overtime_notice_params
      # attendancesテーブルの（指示者確認、変更）
      params.require(:user).permit(attendances: [:overtime_work, :indicater_reply, :change, :indicater_check, :overtime_finished_at, :indicater_check_anser])[:attendances]
    end
    
    # 1か月の承認モーダルのparamsは未設定
    
    # beforeフィルター
    
    # 管理権限者、もしくは現在ログイン中のユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end
    end
end