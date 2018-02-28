class UsersController < ApplicationController

	http_basic_authenticate_with name: "dhh", password: "secret", only: :index

	def index
		@users = User.all
	end

	def display
		@users = User.joins("INNER JOIN events_users ON events_users.user_id = users.id AND events_users.event_id = #{params[:event_id]}")
		@event = Event.find(params[:event_id])
	end

	def new

	end

	def create
		@article = Article.find(params[:article_id])
		@comment = @article.comments.create(comment_params)
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