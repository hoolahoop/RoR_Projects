class RegistrationsController < Devise::RegistrationsController

  def destroy
		@events = Event.where(user_id: resource.id)
		@events.each do |event|
			event.destroy
		end
    super
  end

end 