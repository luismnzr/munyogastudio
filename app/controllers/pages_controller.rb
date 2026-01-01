class PagesController < ApplicationController
    skip_before_action :authenticate_user!, only: [:home, :calendario]

  def home
  end

  def calendario
    start_date = Date.today
    end_date = start_date + 7.days
    @class_sessions = ClassSession.where(date: start_date..end_date).order(:date, :start_time)
    @sessions_by_date = @class_sessions.group_by(&:date)
  end
end