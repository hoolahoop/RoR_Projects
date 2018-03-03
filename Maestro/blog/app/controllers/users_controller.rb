class UsersController < ApplicationController

	http_basic_authenticate_with name: "dhh", password: "secret", only: :index

	def index
		@users = User.all
	end

	def display
		@users = User.joins("INNER JOIN event_users ON event_users.user_id = users.id AND event_users.event_id = #{params[:event_id]}")
		@event = Event.find(params[:event_id])
	end

	def new
		@users = User.new
		@event = Event.find(params[:event_id])
	end

	def create
		@user_check = true;
		@event = Event.new(event_user_params)
		@event.users.each do |user|
			user.password = SecureRandom.base64
			user.password_confirmation = user.password
			#test all saves here
			if(!user.try(:save))
				user_check = false;
			end
		end
		Rails.logger.event.debug("User check: #{@user_check}")
		if(@user_check)
			#add all saves here
			#add all associations here
			@event.users.each do |user|
				@user_in_database = User.find_by email: user.email
				if (@user_in_database.nil?)
					User.transaction do
						user.save
					end
					Rails.logger.event.debug("User id check: #{@user}")
					@event_user = EventUser.new(user_id: user.id, event_id: params[:event_id])
					@event_user.save
				else
					Rails.logger.event.debug("User in database id check: #{@user_in_database}")
					@event_user_check = EventUser.find_by user_id: @user_in_database.id, event_id: params[:event_id]
					if (@event_user_check.nil?)
						@event_user = EventUser.new(user_id: @user_in_database.id, event_id: params[:event_id])
						@event_user.save
					end
					
				end
			end
			redirect_to event_display_path(params[:event_id])
		else
			render 'new'
		end
	end

	def remove
		@event = Event.find(params[:event_id])
		@user = User.find(params[:id])
		@join = EventUser.find_by event_id: @event.id, user_id: @user.id
		@join.destroy
		
		redirect_to event_display_path(@event.id)
	end

	private
		def event_user_params
			#params.require(:user).permit(:first_name, :last_name, :email)
			params.require(:event).permit(users_attributes: [:first_name, :last_name, :email, :_destroy])
		end

		def random_password
			random_pass = SecureRandom.base64

		end
end