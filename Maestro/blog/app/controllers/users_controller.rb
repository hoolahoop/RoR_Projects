class UsersController < ApplicationController

	http_basic_authenticate_with name: "dhh", password: "secret", only: :destroy

	def index
		@users = User.all
	end

end