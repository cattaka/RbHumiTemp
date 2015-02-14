class Humitemp < ActiveRecord::Base
  belongs_to :box
  validates :box, presence: true
  validates :humidity, presence: true
  validates :temperature, presence: true
  validates :measured_at, presence: true
end
