module Api
  class MeetingsController < Api::ApplicationController
    
    before_action :set_meeting, only: [:show, :destroy, :update]

    def index
      @meetings = Meeting.paginate(page_params).order(order)
      @meetings = @meetings.where("name ilike :q", q: "%#{ params[:q]}%" ) if params[:q].to_s != ''
    end

    def show
      @users = @meeting.participants
    end

    def create
      @meeting = Meeting.new meeting_params
      if !@meeting.save
        render :status => :forbidden, :text => "input_error"
        return
      end
      create_participants
      render 'show'
    end

    def update
      render 'show'
    end

    def destroy
      @meeting.destroy
      render 'show'
    end

    def default_order
      'started_at DESC'
    end

    private
      def create_participants
        return if not participants_params
        # TODO add role
        participants_params.each_with_index { |p,i| @meeting.add_user(p[i][:id], role) }
        @meeting.save
      end

      def participants_params
        params[:participants]
      end

      def set_meeting
        @meeting = Meeting.find_by_id(params[:id])
        if @meeting.nil?
          render :status => :not_found, :text => 'not_found' 
          return
        end
      end

      def meeting_params
        params.require(:meeting).permit(:id,:name,:started_at,:started_at_date,:started_at_time)
      end
  end
end