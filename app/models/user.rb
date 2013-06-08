class User < ActiveRecord::Base
  attr_accessible :name

  def self.authenticate(username, password)
    User.find_by_name(username)
  end
end
