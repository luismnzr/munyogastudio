module Admin
  class ClassSessionsController < Admin::ApplicationController
    before_action :set_class_session, only: [:show, :edit, :update, :destroy]

    def index
      @class_sessions = ClassSession.upcoming
    end

    def show
      @reservations = @class_session.reservations.includes(:user).order(created_at: :desc)
    end

    def new
      @class_session = ClassSession.new
    end

    def create
      @class_session = ClassSession.new(class_session_params)
      if @class_session.save
        redirect_to admin_class_sessions_path, notice: 'Class created successfully'
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @class_session.update(class_session_params)
        redirect_to admin_class_session_path(@class_session), notice: 'Class updated successfully'
      else
        render :edit
      end
    end

    def destroy
      @class_session.destroy
      redirect_to admin_class_sessions_path, notice: 'Class deleted successfully'
    end

    private

    def set_class_session
      @class_session = ClassSession.find(params[:id])
    end

    def class_session_params
      params.require(:class_session).permit(:class_type, :date, :start_time, :end_time, :instructor_name, :capacity, :description)
    end
  end
end
