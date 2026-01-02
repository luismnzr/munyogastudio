class PagesController < ApplicationController
    skip_before_action :authenticate_user!, only: [:home, :calendario]

  def home
  end

  def calendario
    # Get week offset from params (default to current week)
    week_offset = params[:week].to_i

    # Calculate the start of the week (Monday)
    today = Date.today
    start_of_week = today.beginning_of_week(:monday) + week_offset.weeks
    end_of_week = start_of_week + 6.days

    @current_week_offset = week_offset
    @start_of_week = start_of_week
    @end_of_week = end_of_week

    @class_sessions = ClassSession.where(date: start_of_week..end_of_week).order(:date, :start_time)
    @sessions_by_date = @class_sessions.group_by(&:date)
  end
end