class Attendance < ApplicationRecord
  belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
  enum indicater_reply: { "なし" => 0, "承認" => 1, "否認" => 2, "申請中" => 4 }, _prefix: true
  enum indicater_reply_edit: { "なし" => 0, "承認" => 1, "否認" => 2, "申請中" => 4 }, _prefix: true
  enum indicater_reply_month: { "なし" => 0, "承認" => 1, "否認" => 2, "申請中" => 4 }, _prefix: true
  
  # 出勤時間が存在しない場合の退勤時間は無効
  # validate :finished_at_is_invalid_without_a_started_at
  # 出勤、退勤時間が共に存在する場合、出勤時間より早い退勤時間は無効
  # validate :started_at_than_finished_at_fast_if_invalid
  
  # def finished_at_is_invalid_without_a_started_at
  #   errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  # end
  
  # def started_at_than_finished_at_fast_if_invalid
  #   if started_at.present? && finished_at.present?
  #     errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
  #   end
  # end
end
