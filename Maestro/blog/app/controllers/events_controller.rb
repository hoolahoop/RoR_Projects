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

	#Guest actions

	def display
		@guests = Guest.where(event_id = params[:event_id])
		@event = Event.find(params[:event_id])
	end

	def add
		@guests = Guest.new
		@event = Event.find(params[:event_id])
		@user = User.find(@event.user_id)
	end

	def make
		Rails.logger.event.debug("===New Create===\n")

		@event = Event.new(event_params)
		
		#Remove guests that aren't in the list.
		@guests = Guest.where(event_id: @event.id)
		@guests.each do |guest|
			@remove_guest = true
			@event.guests.each do |eventGuest|
				if (guest.email == eventGuest.email && guest.event_id == eventGuest.event_id)
					@remove_guest = false
				end
			end
			if (@remove_guest)
				Guest.transaction do
					guest.remove
				end
			end
		end

		#Add guests that aren't in the list. Add user accounts for new guests.
		@event.guests.each do |guest|
			#Check if guest record is in database. If it isn't, add it.
			@guest_in_database = Guest.find_by email: guest.email, event_id: @event.id
			Rails.logger.event.debug("Guest in database check. Guest object: #{@guest_in_database}.")
			if (@guest_in_database.nil?)
				@newGuest = Guest.new
				@newGuest.email = guest.email
				@newGuest.first_name = guest.first_name
				@newGuest.last_name = guest.last_name
				@newGuest.event_id = @event.id
				Guest.transaction do
					@newGuest.save
				end
			end
			#Check if user with same email as guest is in database. If it isn't, add it.
			@user_in_database = User.find_by email: guest.email
			Rails.logger.event.debug("User in database check. User object: #{@user_in_database}.")
			if (@user_in_database.nil?) # if user is not in the database (unique email check)
				# create a new user
				@user = User.new
				@user.first_name = guest.first_name
				@user.last_name = guest.last_name
				@user.email = guest.email
				@user.password = SecureRandom.base64
				@user.password_confirmation = @user.password
				User.transaction do
					@user.save
				end
				Rails.logger.event.debug("User id check: #{@user.id}")
			end
		end



		Rails.logger.event.debug("===Redirect to Event Guests Page===\n")
		redirect_to event_display_path(params[:event_id])

	end

	def remove
		@guest = Guest.find(params[:guest_id])
		@guest.destroy
		
		redirect_to event_display_path(@event.id)
		#redirect_to event_display_path(resource.id)
	end

	private
		def event_params
			params.require(:event).permit(
				:name, 
				:description, 
				:option, 
				:street_address, 
				:apartment_number, 
				:city, 
				:date, 
				:time, 
				:password,
				guests_attributes: [:id, :_destroy, :email, :first_name, :last_name, :event_id]
				)
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