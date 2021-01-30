class Base < ApplicationRecord

  validates :base_number, presence: true, uniqueness: true
  validates :base_name, presence: true
end