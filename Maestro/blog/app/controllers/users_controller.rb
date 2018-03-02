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
		@event = Event.find(params[:event_id])

		#get all users being added
		@user = User.new

		@userArray = []
		@userArray << User.new()

		#generate random password for each new user

		User.transaction do
			#add all saves here
		end

		EventUser.transaction do
			#add all associations here
		end

		#@comment = @article.comments.create(comment_params)
		redirect_to article_path(@article)
	end

	def remove
		@event = Event.find(params[:event_id])
		@user = User.find(params[:id])
		@join = EventUser.find(params[event_id: :event_id, user_id: :id])
		@join.destroy
		
		redirect_to event_display_path(@event)
	end

	private
		def comment_params
			params.require(:comment).permit(:commenter, :body)
		end

end