Monopwww::App.controllers :admin do
  get :index do
    render 'index'
  end
  get :users do
    @users = Monopwww::App.cache['site_users']
    render 'users'
  end

  get :user_del, :with => :id do
    users = Monopwww::App.cache['site_users']
    users.delete_if{|u| u[:name] == params[:id]}
    Monopwww::App.cache['site_users'] = users
    redirect url(:admin, :users)
  end

  get :games_gen do

    games =[]
    10.times do|ind|

      g = Game.new(Padrino.root('/lib/monop_lib/'))
      g.id = ind
      g.update_interval =1
      g.ui_show_ok_when_endround = true

      #g.add_player("fedor(b)")
      #g.add_player("vitek(b)")

      g.start

      Monopwww::App.cache["game#{ind}"] = g

      games<<g
    end
    Monopwww::App.cache[:max_gid] = 10

    redirect url(:site, :games)
  end
  get :logs do
    @logs = Monopwww::App.cache['site_logs'] || []
    render 'logs'
  end
  get :clear_logs do
    Monopwww::App.cache['site_logs'] = []
    redirect url(:admin, :logs)
  end
end
