class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [ :login, :register ]

  def login
    user = User.find_by(email_address: params[:email_address])
    if user&.authenticate(params[:password])
      session = Session.create!(
        user: user,
        ip_address: request.remote_ip,
        user_agent: request.user_agent
      )
      render json: {
        data: {
          token: session.token,
          user: user.as_json(except: :password_digest)
        }
      }, status: :ok
    else
      render json: { error: "Invalid email address or password" }, status: :unauthorized
    end
  end

  def register
    user = User.new(
      email_address: params[:email_address],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
    if user.save
      session = Session.create!(
        user: user,
        ip_address: request.remote_ip,
        user_agent: request.user_agent
      )
      render json: {
        data: {
          token: session.token,
          user: user.as_json(except: :password_digest)
        }
      }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def logout
    Current.session&.destroy
    render json: { message: "Logged out successfully" }, status: :ok
  end
end
