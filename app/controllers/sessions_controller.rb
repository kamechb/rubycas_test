class SessionsController < ApplicationController
  def new
  end

  def create
    credentials = {username: params[:name], password: params[:password]}

    # login_to_service需要请求lg(login_ticket), 官方的cas server不支持，
    # 因此无法在client端设置登录页面，必须到server端登录页面进行登录
    resp = RubyCAS::Filter.login_to_service(self, credentials, session[:return_to] || posts_path)

    if resp.is_success?
      puts session[:cas_user]
    end
  end
end
