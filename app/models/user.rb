class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  # remember_tokenメソッドに仮想の属性を作成
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :affiliation, length: { in: 2..50 }, allow_blank: true
  validates :basic_work_time, presence: true
  validates :work_time, presence: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  
  # インポート機能
  def self.import(file)
    CSV.foreach(file.path, encoding: 'cp932:utf-8', headers: true) do |row|
       # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
      user = find_by(id: row["id"]) || new
       # CSVからデータを取得し、設定する
      user.attributes = row.to_hash.slice(*updatable_attributes)
      user.save!(:validation => false)
    end
  end
  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["name", "email", "affiliation", "employee_number", "uid", "basic_work_time",
     "designated_work_start_time", "designated_work_end_time","superior","admin","password"]
  end
  
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す。
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続的セッションのためハッシュ化したトークンをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # トークンがダイジェストと一致すればtrueが返ってくる
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了となる。
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
end