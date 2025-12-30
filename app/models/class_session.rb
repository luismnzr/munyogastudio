class ClassSession < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_many :users, through: :reservations

  validates :class_type, presence: true
  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validate :end_time_after_start_time

  scope :upcoming, -> { where('date >= ?', Date.today).order(:date, :start_time) }
  scope :past, -> { where('date < ?', Date.today).order(date: :desc, start_time: :desc) }
  scope :on_date, ->(date) { where(date: date).order(:start_time) }

  def available_spots
    capacity - confirmed_reservations_count
  end

  def confirmed_reservations_count
    reservations.where(status: 'confirmed').count
  end

  def full?
    available_spots <= 0
  end

  def has_space?
    available_spots > 0
  end

  def datetime
    return nil unless date && start_time
    Time.zone.local(date.year, date.month, date.day, start_time.hour, start_time.min)
  end

  def to_s
    "#{class_type} - #{date.strftime('%A, %b %d')} at #{start_time.strftime('%I:%M %p')}"
  end

  private

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end
end
