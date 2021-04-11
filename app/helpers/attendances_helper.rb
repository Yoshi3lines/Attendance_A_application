module AttendancesHelper

  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    false
  end
  
  # 出社時間と退勤時間を受け取り、在社時間を計算して返す。
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  # def working_times(start, finish)
  #   if tomorrow_edit = true
  #     format("%.2f", (((finish - start) / 60) / 60.0) + 24)
  #   else
  #     format("%.2f", (((finish - start) / 60) / 60.0))
  #   end
  # end
  
  # 時間外勤務
  def overtime_worked_on(finish, end_time, tomorrow)
    if tomorrow == true
      # finishとend_timeの'時'と'分'をそれぞれ計算し、差分を合わせるために、分割を60で割る
      format("%.2f", (((finish.hour - end_time.hour) + ((finish.min - end_time.min) / 60.0) + 24)))
    else
      format("%.2f", (((finish.hour - end_time.hour) + ((finish.min - end_time.min) / 60.0))))
    end
  end
  
  # def edit_overtime_worked_on(start, finish, tomorrow_ed)
  #   if tomorrow_edit == true
  #     # finishとend_timeの'時'と'分'をそれぞれ計算し、差分を合わせるために、分割を60で割る
  #     format("%.2f", (((finish.hour - start.hour) + ((finish.min - start.min) / 60.0) + 24)))
  #   else
  #     format("%.2f", (((finish.hour - start.hour) + ((finish.min - start.min) / 60.0))))
  #   end
  # end
  
end