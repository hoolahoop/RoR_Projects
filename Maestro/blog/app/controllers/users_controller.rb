class UsersController < ApplicationController

	http_basic_authenticate_with name: "dhh", password: "secret", only: :index

	def index
		@users = User.all
	end

end