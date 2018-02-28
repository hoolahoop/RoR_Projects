class EventsController < ApplicationController

	def index
		no_user and return
		@events = Event.where(user_id: current_user.id)
	end
	
	def show
		no_user and return
		@event = Event.find(params[:id])
		is_user_invalid(@event) and return
		@option
		case @event.option
		when 1
			@option = "Secret Santa"
		else
			@option = "New Option, Not Available Yet"
		end
	end

	def new
		no_user and return
		@event = Event.new
	end

	def edit
		no_user and return
		@event = Event.find(params[:id])
		is_user_invalid(@event) and return
	end

	def create
		no_user and return
 		@event = Event.new(event_params)
 		@event.user_id = current_user.id

 		if @event.save
 			redirect_to @event
 		else
 			render 'new'
 		end
	end

	def update
		no_user and return
		@event = Event.find(params[:id])
		is_user_invalid(@event) and return

		if @event.update(event_params)
			redirect_to @event
		else
			render 'edit'
		end
	end

	def destroy
		no_user and return
		@event = Event.find(params[:id])
		is_user_invalid(@event) and return
		@event.destroy

		redirect_to events_path
	end

	private
		def event_params
			params.require(:event).permit(:name, :description, :option, :street_address, :apartment_number, :city, :date, :time, :password)
		end

		def no_user()
			if(current_user.nil?)
				return redirect_to welcome_index_path
			end
		end

		def is_user_invalid(event_param)
			if(current_user.id != event_param.user_id)
				return redirect_to events_path
			end
		end
end