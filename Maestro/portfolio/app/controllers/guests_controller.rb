class GuestsController < ApplicationController

	def edit
		#Rails.logger.event.debug("Edit start. ===================================================")
		no_user and return
		@guest = Guest.find(params[:id])
		@event = Event.find(@guest.event_id)
		is_user_invalid(@event) and return
		@allGuests = Guest.where(event_id: @event.id)
		@guests = @allGuests.where.not(id: @guest.id)
		@rules = Rule.where(event_id: @event.id)
		@guestRules = nil
		if !@rules.nil?
			@rules.each do |rule|
				@guestRules += @guests.where(id: rule.guest_id)
			end
		end
		#Rails.logger.event.debug("Object guestRules: #{@guestRules}")
		#Rails.logger.event.debug("Edit end. ===================================================\n")
	end

	def update
		Rails.logger.event.debug("Update start. ===================================================")
		no_user and return
		@guest = Guest.find(params[:id])
		@event = Event.find(@guest.event_id)
		is_user_invalid(@event) and return
		@guest_test = Guest.new(guest_params)
		Rails.logger.event.debug("Object guest: #{@guest}")
		Rails.logger.event.debug("Object guest_test: #{@guest_test.rules_attributes}")

		if @guest.update(guest_params)
			redirect_to event_display_path(@event)
		else
			render 'edit'
		end

		Rails.logger.event.debug("Update end. ===================================================\n")
	end

	private
		def guest_params
			params.require(:guest).permit(
				:id,
				:email,
				:first_name,
				:last_name,
				:event_id,
				rules_attributes: [:id, :_destroy, :email, :guest_id, :event_id]
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
