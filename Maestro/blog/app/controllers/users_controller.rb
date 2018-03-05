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
		@owner = User.find(@event.user_id)
	end

	def create
		Rails.logger.event.debug("===New Create===\n")
		@user_check = true;

		#@event = Event.new(event_params)
		@event = Event.new(event_user_params)

		@event.users.each do |user|
			user.password = SecureRandom.base64
			user.password_confirmation = user.password
			#test all saves here
			if(!user.try(:save))
				user_check = false;
			end
		end
		Rails.logger.event.debug("Can we save all users: #{@user_check}. If true, continue.")
		if(@user_check)
			#add all saves here
			#add all associations here
			@event.users.each do |user|
				@user_in_database = User.find_by email: user.email
				Rails.logger.event.debug("User in database check. Id: #{@user_in_database.id}. Email: #{@user_in_database.email}.")
				if (@user_in_database.nil?) # if user is not in the database (unique email check)
					# create a new user
					User.transaction do
						user.save
					end
					Rails.logger.event.debug("User id check: #{@user}")
					@event_user = EventUser.new(user_id: user.id, event_id: params[:event_id])
					# create a new join table record
					EventUser.transaction do
						@event_user.save
					end
				else
					@event_user_join = EventUser.find_by user_id: @user_in_database.id, event_id: params[:event_id]
					Rails.logger.event.debug("Is there a join on this event for this user?. Join object: #{@event_user_join}. If this is nil, no join exists.")
					if (@event_user_join.nil?)
						@event_user = EventUser.new(user_id: @user_in_database.id, event_id: params[:event_id])
						EventUser.transaction do
							@event_user.save
						end
					else
						Rails.logger.event.debug("Join user_id: #{@event_user_join.user_id}. Join event_id: #{@event_user_join.event_id}.")
						Rails.logger.event.debug("Try removing join.")
						EventUser.transaction do
							@event_user_join.delete
						end
						Rails.logger.event.debug("Removal success.")
					end
				end
			end
			Rails.logger.event.debug("===Redirect to Event Guests Page===\n")
			redirect_to event_display_path(params[:event_id])
		else
			render 'new'
			Rails.logger.event.debug("===Render New===\n")
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
		def event_params
			params.require(:event).permit(:id)
		end

		def event_user_params
			#params.require(:user).permit(:first_name, :last_name, :email)
			#params.require(:event).permit(:event_id, users_attributes: [:id, :first_name, :last_name, :email, :_destroy])
			params.require(:event).permit(
				:id,
				user_id: :owner,
				users_attributes: [:id, :first_name, :last_name, :email, :_destroy],
				event_users_attributes: [:id, :event_id, :user_id, :_destroy]
				)
		end

		def random_password
			random_pass = SecureRandom.base64

		end
end