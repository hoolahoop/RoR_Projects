class EventsController < ApplicationController

	def index
		if(!current_user.nil?)
			@current_user = current_user.id
			@events = Event.find_by(user_id: @current_user)
		else
			redirect_to welcome_index_path
		end
	end
	
	def show
		@events = Event.find(params[:id])
	end

	def new
		@events = Event.new
	end

	def edit
		@events = Event.find(params[:id])
	end

	def create
 		@event = Event.new(event_params)

 		if @event.save
 			redirect_to @event
 		else
 			render 'new'
 		end
	end

	def update
		@event = Event.find(params[:id])

		if @event.update(event_params)
			redirect_to @event
		else
			render 'edit'
		end
	end

	def destroy
		@event = Event.find(params[:id])
		@event.destroy

		redirect_to events_path
	end

	private
		def event_params
			params.require(:event).permit(:name, :description, :option, :street_address, :apartment_number, :city, :date, :time, :password)
		end
end
