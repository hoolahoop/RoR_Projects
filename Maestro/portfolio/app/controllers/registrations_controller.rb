class RegistrationsController < Devise::RegistrationsController

  def destroy
		@events = Event.where(user_id: resource.id)
		@events.each do |event|
			@guests = Guest.where(event_id: event.id)
			@guests.each do |guest|
				guest.destroy
			end
			event.destroy
		end
		@guests = Guest.where(email: resource.email)
		@guests.each do |guest|
			guest.destroy
		end
    super
  end

end 