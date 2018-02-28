class UsersController < ApplicationController

	http_basic_authenticate_with name: "dhh", password: "secret", only: :index

	def index
		@users = User.all
	end

	def display
		#@event = Event.find(params[:event_id])
		#@users = EventUser.joins(params[event_id: :event_id])
		@users = User.joins("INNER JOIN events_users ON events_users.user_id = users.id AND events_users.event_id = #{params[:event_id]}")

		#@users_events = @events_users.where(event_id: :event_id)
		#@users = @users.where
	end

	def new

	end

	def create
		@article = Article.find(params[:article_id])
		@comment = @article.comments.create(comment_params)
		redirect_to article_path(@article)
	end

	def destroy
		@article = Article.find(params[:article_id])
		@comment = @article.comments.find(params[:id])
		@comment.destroy
		redirect_to article_path(@article)
	end

	private
		def comment_params
			params.require(:comment).permit(:commenter, :body)
		end

end