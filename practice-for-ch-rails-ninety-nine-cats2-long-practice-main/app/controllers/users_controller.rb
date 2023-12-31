class UsersController < ApplicationController
    def new
        render :new 
    end

    def create
        user = User.new(user_params)
        if user.save
            user.login!
            redirect_to cats_url
        else
            render :new
        end
    end

    private
    def user_params
        params.require(:user).permit(:username, :password)
    end
end