class SignupController < ApplicationController
    def create
        user = User.new(user_params)

        if user.save
            payload = { user_id: user.id }
            session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
            tokens = sessions.login

            response.set_cookie(JWTSessions.access_cookie,
                                value: token[:access],
                                httponly: true,
                                secure: Rails.env.productions?)
            
            render json: { csrf: tokens[:csrf] }
        else
            render json: { error: user.error.full_messages.join(' ') }, status: :unprocessable_entity
        end

    end

    private

        def user_params
            params.permit(:email, :password, :password_confirmation)
        end
end