class GuestsController < ApplicationController

	def edit
		no_user and return
		@guest = Guest.find(params[:id])
		@event = Event.find(@guest.event_id)
		is_user_invalid(@event) and return
	end

	def update
		no_user and return
		@guest = Guest.find(params[:id])
		@event = Event.find(@guest.event_id)
		is_user_invalid(@event) and return

		if @guest.update(guest_params)
			redirect_to @guest
		else
			render 'edit'
		end
	end

	private
		def guest_params
			params.require(:event).permit(
				:id,
				:email,
				:first_name,
				:last_name,
				:event_id,
				rules_attributes: [:id, :_destroy, :email, :guest_id]
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
