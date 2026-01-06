class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :class_session

  validates :user_id, uniqueness: { scope: :class_session_id, conditions: -> { where(status: 'confirmed') } }
  validates :status, presence: true, inclusion: { in: %w[confirmed cancelled] }
  validate :user_has_credits, on: :create
  validate :class_not_full, on: :create
  validate :class_not_in_past, on: :create

  scope :confirmed, -> { where(status: 'confirmed') }
  scope :upcoming, -> { joins(:class_session).where('class_sessions.date >= ?', Date.today).order('class_sessions.date ASC, class_sessions.start_time ASC') }
  scope :past, -> { joins(:class_session).where('class_sessions.date < ?', Date.today).order('class_sessions.date DESC, class_sessions.start_time DESC') }

  def finished?
    return false unless class_session&.datetime
    class_session.datetime < Time.current
  end

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

  def class_not_in_past
    return unless class_session&.datetime
    if class_session.datetime < Time.current
      errors.add(:base, "Cannot book a class that has already started")
    end
  end
end
