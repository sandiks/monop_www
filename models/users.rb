class Users < Sequel::Model

    def self.get_game_users
      users = [{id:1, name:"kilk", email:"kilk@gmail.com"},{id:2, name:"bob", email:"bob@gmail.com"},{id:3, name:"andy", email:"andy@gmail.com"}]
    end
end
