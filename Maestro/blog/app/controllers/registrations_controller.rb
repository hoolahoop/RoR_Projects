class RegistrationsController < Devise::RegistrationsController

  def destroy
		@events = Event.where(user_id: resource.id)
		@events.each do |event|
			@event_joins = EventUser.where(event_id: event.id)
			@event_joins.each do |join|
				join.destroy
			end
			event.destroy
		end
    super
  end

end 