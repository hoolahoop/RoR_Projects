class Guest < ApplicationRecord
  belongs_to :event
  has_many :rules, dependent: :destroy

  accepts_nested_attributes_for :rules, :allow_destroy => true
  
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
end
