Warden::Strategies.add(:password) do
    def valid?
      params["name"] || params["password"]
    end

    def authenticate!
      #user = Users.filter(email: params["email"]).first
      #if !user.nil? && user.password == params["password"].strip
      users = Monopwww::App.cache['site_users']
      user = users.find {|u| u[:name] == params["name"]}
      if !user.nil?
          success!(user)
      else
          fail!("такой пользователь не найден")
      end
    end
end

Warden::Manager.serialize_into_session { |user| user[:name] }
Warden::Manager.serialize_from_session { |id| Monopwww::App.cache['site_users'].find {|u| u[:name] == id} }
