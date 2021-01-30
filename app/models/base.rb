class Base < ApplicationRecord
  belongs_to :user
  
  validates :base_number, presence: true, uniqueness: true
  validates :base_name, presence: true
end
