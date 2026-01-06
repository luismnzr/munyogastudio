class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
    all_upcoming = current_user.reservations.confirmed.upcoming.includes(:class_session)
    @upcoming_reservations = all_upcoming.reject(&:finished?)
    @past_reservations = current_user.reservations.confirmed.past.includes(:class_session)

    # Add finished classes from today to past reservations
    finished_today = all_upcoming.select(&:finished?)
    @past_reservations = (@past_reservations.to_a + finished_today).sort_by { |r| [r.class_session.date, r.class_session.start_time] }.reverse
  end

  def create
    @class_session = ClassSession.find(params[:class_session_id])

    if @class_session.datetime && @class_session.datetime < Time.current
      redirect_to calendario_path, alert: 'Cannot book a class that has already started'
      return
    end

    @reservation = current_user.reservations.build(class_session: @class_session, status: 'confirmed')

    if @reservation.save
      current_user.decrement!(:yogaclass)
      redirect_to reservations_path, notice: 'Class booked successfully!'
    else
      redirect_to calendario_path, alert: @reservation.errors.full_messages.join(', ')
    end
  end

  def destroy
    @reservation = current_user.reservations.find(params[:id])
    if @reservation.cancel!
      redirect_to reservations_path, notice: 'Reservation cancelled. Credit refunded.'
    else
      redirect_to reservations_path, alert: @reservation.errors.full_messages.join(', ')
    end
  end
end
