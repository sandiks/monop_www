Monopwww::App.controllers :site do

    define_method :logged_uname do
        current_user.nil? ? "unknown" : current_user[:name]
        #current_user[:name]
    end

    get :index do
        @title = "game::index"
        LogHelper.log_req(request)

        render 'index'

    end
    get :lang, :with => :id  do
        I18n.locale = params[:id]

        redirect '/site'

    end

    get :games do
        LogHelper.log_req(request)
        @title = "game::index"

        #HardWorker.perform_async('bob', 5)
        @games =[]
        @mygames = []
        for ind in 0..(Monopwww::App.cache[:max_gid].to_i)
            g = Monopwww::App.cache["game#{ind}"]
            @games << g if !g.nil?
            if !g.nil? && g.players.any?{|pl| pl.name == logged_uname}
                @mygames << g
            end
        end

        #flash[:error] = @mygames.map { |e| [e.id, e.players.map{ |pl| pl.name  }]  }
        render 'games'

    end

    get :test do
        @title = "game::new"
        render 'test'
    end
    get :map do
        @title = "site:game map"

        g = Monopwww::App.cache['game0']

        @info =  g.cells.map { |cc| {id: cc.id, type: cc.type, descr: cc.info,  title: cc.name, rent: cc.rent_info, price: cc.cost, hcost: cc.house_cost } }
        #@mypid =  g.players.select { |pl| pl.name ==  logged_uname }.first.id
        @players =  g.players.map { |pl| pl.name  }
        @player_colors =  GameHelper.colors
        @player_images =  GameHelper.player_images
        @game =g

        render 'map', :layout => false
    end
    get :new_game do
        @title = "game::new"
        render 'new_game'
    end

    post :new_game do
        g = Game.new(Padrino.root('/lib/monop_lib/'))
        gid = Monopwww::App.cache[:max_gid].to_i+1
        session[:gameid] = Monopwww::App.cache[:max_gid] = gid
        g.id = gid
        g.update_interval =2

        g.players << Player.new(0, logged_uname, 0 , 15000)
        g.players << Player.new(1, "bot1", 1 , 15000)

        g.start

        Monopwww::App.cache["game#{session[:gameid]}"] = g
        redirect url(:site, :games)
    end

    get :chat do
        @title = "site::chat"
        @messages = SiteHelper.chat_messages
        render 'chat'

    end

end
