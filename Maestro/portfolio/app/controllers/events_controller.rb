class EventsController < ApplicationController

	def index
		#Rails.logger.event.debug("Index start. ===================================================\n")
		no_user and return
		@events = Event.where(user_id: current_user.id)
		@guestEvents = Event.joins("INNER JOIN guests ON guests.event_id = events.id AND guests.email = '#{current_user.email}'")
		#Rails.logger.event.debug("Index end. =====================================================\n")
	end
	
	def show
		no_user and return
		@event = Event.find(params[:id])
		@isGuest = is_guest(@event)
		if is_owner(@event) || @isGuest
			@option
			case @event.option
			when 1
				@option = "Secret Santa"
			else
				@option = "New Option, Not Available Yet"
			end
		else
			redirect_to events_path
		end
		#is_user_invalid(@event) and return
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
		no_user and return
		@event = Event.find(params[:event_id])
		@isGuest = is_guest(@event)
		@isOwner = is_owner(@event)
		if (@isOwner || @isGuest)
			@guests = Guest.where(event_id: params[:event_id])
		else
			redirect_to events_path
		end
	end

	def add
		no_user and return
		@event = Event.find(params[:event_id])
		is_user_invalid(@event) and return
		@user = User.find(@event.user_id)
		@guests = Guest.new
	end

	def make
		no_user and return
		@event = Event.new(event_params)
		# Rails.logger.event.debug("Event user id: <#{@event.user_id}>.\n")
		is_user_invalid(@event) and return
		# Add guests that aren't in the list. Add user accounts for new guests. Remove users with _delete = true.
		@event.guests.each do |guest|
			# Check if user with same email as guest is in database. If it isn't, add it.
			@user_in_database = User.find_by email: guest.email
			if (@user_in_database.nil?) # if user is not in the database (unique email check)
				# create a new user
				@user = User.new
				@user.first_name = guest.first_name
				@user.last_name = guest.last_name
				@user.email = guest.email
				@user.password = SecureRandom.base64
				@user.password_confirmation = @user.password
				@user.save
			end
			# Check if guest record is in database. If it isn't, add it. Also, owners of events can't be guests.
			@guest_in_database = Guest.find_by email: guest.email, event_id: @event.id
			if (@guest_in_database.nil? && guest.email != current_user.email)
				# create a new guest
				@newGuest = Guest.new
				@newGuest.email = guest.email
				@newGuest.first_name = !@user_in_database.nil? ? @user_in_database.first_name : guest.first_name
				@newGuest.last_name = !@user_in_database.nil? ? @user_in_database.last_name : guest.last_name
				@newGuest.event_id = params[:event_id]
				@newGuest.save
			end
			if (guest._destroy)
				@guestRemove = Guest.find(guest.id)
				@guestRemove.destroy
			end
		end
		redirect_to event_display_path(params[:event_id])
	end

	def remove
		no_user and return
		@event = Event.find(params[:event_id])
		is_user_invalid(@event) and return
		@guest = Guest.find(params[:id])
		@guest.destroy
		redirect_to event_display_path(params[:event_id])
	end

	private
		def event_params
			params.require(:event).permit(
				:id,
				:name, 
				:description, 
				:option, 
				:street_address, 
				:apartment_number, 
				:city, 
				:date, 
				:time, 
				:password,
				:user_id,
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

		def is_owner(event_param)
			if(current_user.id == event_param.user_id)
				return true
			end
			return false
		end

		def is_guest(event_param)
			@guestCheck = Guest.find_by event_id: event_param.id, email: current_user.email
			if(!@guestCheck.nil?)
				return true
			end
			return false
		end
end