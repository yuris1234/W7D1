class SessionsController < ApplicationRecord
    def new 
        render :new
    end

    def create
        @user = User.find_by_credentials(params[:user][:username], params[:user][:password])
        @user.reset_session_token!
        session[:session_token] = user.session_token
        if @user.save
            redirect_to cats_url
        else
            render :new
        end 
    end

    def destroy
        if current_user
            current_user.reset_session_token!
        end
        session[:session_token] = nil
    end
end