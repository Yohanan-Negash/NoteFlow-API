module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
    attr_reader :current_user
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :authenticate_request, **options
    end
  end

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    
    session = Session.find_by(token: header)
    
    if session
      Current.session = session
      Current.user = session.user
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def start_new_session_for(user)
    user.sessions.create!(
      user_agent: request.user_agent,
      ip_address: request.remote_ip
    ).tap do |session|
      Current.session = session
    end
  end
end