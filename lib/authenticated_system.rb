module AuthenticatedSystem
  def logged_in?
    current_user
  end

  def current_user
    @current_account ||= (login_from_session || login_from_basic_auth)
  end

  def current_user=(user)
    session[:user] = user && user.name
    @current_user = user
  end

  def authorized?
    logged_in?
  end

  def login_required
    authorized? || access_denied
  end

  def access_denied
    respond_to do |format|
      format.html do
        store_location
        redirect_to '/login'
      end
      format.xml do
        request_http_basic_authentication 'Web Password'
      end
    end
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def login_from_session
    self.current_user = User.find_by_name(session[:user]) if session[:user]
  end

  def login_from_basic_auth
    authenticate_with_http_basic do |username, password|
      self.current_user = User.authenticate(username, password)
    end
  end
end
