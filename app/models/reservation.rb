class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :class_session

  validates :user_id, uniqueness: { scope: :class_session_id, conditions: -> { where(status: 'confirmed') } }
  validates :status, presence: true, inclusion: { in: %w[confirmed cancelled] }
  validate :user_has_credits, on: :create
  validate :class_not_full, on: :create

  scope :confirmed, -> { where(status: 'confirmed') }
  scope :upcoming, -> { joins(:class_session).where('class_sessions.date >= ?', Date.today) }

  def can_cancel?
    return false unless status == 'confirmed'
    return false unless class_session.datetime
    class_session.datetime > 8.hours.from_now
  end

  def cancel!
    if can_cancel?
      transaction do
        update!(status: 'cancelled', cancelled_at: Time.current)
        user.increment!(:yogaclass)
      end
      true
    else
      errors.add(:base, "Cannot cancel - class starts in less than 8 hours")
      false
    end
  end

  private

  def user_has_credits
    errors.add(:base, "No available classes") if user && user.yogaclass <= 0
  end

  def class_not_full
    errors.add(:base, "Class is full") if class_session && class_session.full?
  end
end
