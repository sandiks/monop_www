
Monopwww::App.controllers :sim do


    get :index do
      render 'play'
    end

    get :play do
      @title ="sim::play"

      g = GameHelper.sim_game

      Monopwww::App.cache['game'] = g

      @logs =g.logs.join("<br />")

      render 'play'

    end

    get "/round/:id", :provides => :json do

      begin
          r =params[:id]

          game = Monopwww::App.cache['game']

          logs = game.logs.select{ |l| l.start_with?("[#{r}]")  }
          round = game.round_actions.select { |ra| ra[:round] ==r.to_i}.last


          { :Map => round[:cells].map { |cc| {id: cc.id, text: GameHelper.print_cell_info(cc), color: GameHelper.GetPlayerColorRGB(cc.owner) } },
          :Players => GameHelper.GetPlayerState(round[:players_pos]).map { |a| {id: a[0] , images: a[1] } },
          :Round=> r,
          :GameLog=> logs.join("<br />"),

          }.to_json

      rescue
          p "error"
      end
    end
    get :log do

      #GameHelper.start

      g = GameHelper.sim_game
      @logs =g.logs.join("<br />")

      render 'log'

    end
end
