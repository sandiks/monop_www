
Monopwww::App.controllers :game do

  define_method :logged_uname do
    current_user.nil? ? "unknown" : current_user[:name]
    #current_user[:name]
  end

  define_method :not_registered? do
    not logged_in?
  end

  define_method :get_cached_game do
    g = Monopwww::App.cache['game'+session[:gameid]]

  end

  define_method :get_cached_game_by do |gid|
    g = Monopwww::App.cache['game'+ gid]
  end

  define_method :start_game do |gid|
    g = Monopwww::App.cache['game'+gid]
    g.check_roll_and_make_step if g.curr.bot?
    Monopwww::App.cache['game'+gid] = g
  end

  get :add_player, :with => :id do
    redirect '/sessions/login' if not_registered?

    gid = params[:id].to_s
    g = Monopwww::App.cache['game'+gid]
    bots = ["fedor(b)", "vovas(b)", "mihey(b)","dimon(b)"]
    count = g.players.select { |pl| pl.bot?  }.size
    if g.players.size<4
      g.add_player(bots[count])
      Monopwww::App.cache['game'+gid] = g
    end
    redirect url(:site, :games)
  end

  get :change_roll_mode, :with => :id do
    redirect '/sessions/login' if not_registered?

    gid = params[:id].to_s
    g = Monopwww::App.cache['game'+gid]
    g.is_manual_roll_mode = !g.is_manual_roll_mode
    Monopwww::App.cache['game'+gid] = g
    redirect url(:site, :games)
  end

  get :join, :with => :id do
    redirect '/sessions/login' if not_registered?

    ind = session[:gameid] = params[:id].to_s
    g = Monopwww::App.cache["game#{ind}"]

    exist = g.players.any?{|pl| pl.name == logged_uname}

    if not exist
      g.add_player(logged_uname,0)
    end

    Monopwww::App.cache['game'+session[:gameid]] = g

    #redirect(url(:game, :play, id: params[:id]))
    redirect url(:site, :games)
  end


  get :play do
    redirect '/sessions/login' if not_registered?

    gid = session[:gameid]
    redirect url(:game, :play, id: gid)
  end

  get :play, :with => :id do
    begin
      redirect '/sessions/login' if not_registered?

      session[:gameid] = gid = params[:id].to_s
      g = get_cached_game
      start_game gid

      @info =  g.cells.map { |cc| {id: cc.id, type: cc.type, descr: cc.info,  title: cc.name, rent: cc.rent_info, price: cc.cost, hcost: cc.house_cost } }
      @mypid =  g.players.select { |pl| pl.name ==  logged_uname }.first.id
      @players =  g.players.map { |pl| pl.name  }
      @player_colors =  GameHelper.colors
      @player_images =  GameHelper.player_images
      @game =g

      render 'play', :layout => false
    rescue  => ex
      puts " #{ex.class}, message is #{ex.message}"
      puts ex.backtrace[0..3]
    end
  end

  get :view, :with => :id do
    begin

      session[:gameid] = params[:id].to_s
      g = get_cached_game

      @info =  g.cells.map { |cc| {id: cc.id, type: cc.type, descr: cc.info,  title: cc.name, rent: cc.rent_info, price: cc.cost, hcost: cc.house_cost } }
      @mypid =  "100"
      @players =  g.players.map { |pl| pl.name  }
      @player_colors =  GameHelper.colors
      @player_images =  GameHelper.player_images
      @game =g

      render 'view', layout: false
    rescue  => ex
      puts " #{ex.class}, message is #{ex.message}"
      puts ex.backtrace[0..3]
    end
  end

  get :go, :provides => :json do
    begin
      return if not_registered?

      g = get_cached_game

      if logged_uname == g.curr.name || g.in_begin?|| g.in_trade?|| g.in_auction? || g.state_endround?

        s = params[:comm].to_s
        GameUI.process_command(g, s.strip, logged_uname)
        Monopwww::App.cache['game'+session[:gameid]]= g
      end

      buttons = GameHelper.html_buttons(g,logged_uname)

      {
        :PlayersPos   => g.players.map { |pl| {id:pl.id, pos:pl.pos}  },
        :GameLog      => GameHelper.show_logs(g).join("<br />"),
        :PlayersInfo  => GameHelper.info(g),
        :PlayerButton => buttons,
        :Timer        => g.get_round_timer,
        :Map          => g.cells.map { |cc| {id: cc.id, own: cc.owner, grcount: cc.owgrcount, text: GameHelper.print_cell_info(cc) }}
      }.to_json

    rescue  => ex
      puts " #{ex.class}, message is #{ex.message}"
      puts ex.backtrace[0..3]
    end

  end

  get :update, :provides => :json do
    begin
      return if not_registered?
      g = get_cached_game
      logs = GameHelper.show_logs(g)
      buttons = GameHelper.html_buttons(g,logged_uname)

      {
        :PlayersPos   => g.players.map { |pl| {id:pl.id, pos:pl.pos}  },
        :GameLog      => logs.join("<br />"),
        :PlayersInfo  => GameHelper.info(g),
        :PlayerButton => buttons,
        :Timer        => g.get_round_timer,
        :Map          => g.cells.map { |cc| {id: cc.id, own: cc.owner,grcount: cc.owgrcount,hh:cc.houses_count , text: GameHelper.print_cell_info(cc)}},
      }.to_json

    rescue  => ex
      puts " #{ex.class}, message is #{ex.message}"
      puts ex.backtrace[0..3]
    end

  end

  get :view_update, :provides => :json do
    begin
      #return if not_registered?
      g = get_cached_game
      {
        :PlayersPos   => g.players.map { |pl| {id:pl.id, pos:pl.pos}  },
        :GameLog      => GameHelper.show_logs(g).join("<br />"),
        :PlayersInfo  => GameHelper.info(g),
        :PlayerButton => "",
        :Timer        => g.get_round_timer,
        :Map          => g.cells.map { |cc| {id: cc.id, own: cc.owner,grcount: cc.owgrcount,hh:cc.houses_count , text: GameHelper.print_cell_info(cc)}},
      }.to_json

    rescue  => ex
      puts " #{ex.class}, message is #{ex.message}"
      puts ex.backtrace[0..3]
    end

  end

  get :player_cells, :provides => :json do
    g = get_cached_game
    html = partial 'shared/player_cells', :object => g
    { player_cells: html}.to_json
  end

  get :show_game_logs, :provides => :json do
    g = get_cached_game
    r = g.round
    logs = g.xlogs[-10..-1] #.select{ |l| l.start_with?("[#{r}]") or l.start_with?("[#{r-1}]") }
    { xlogs: logs.join("<br />")}.to_json
  end

  get :mortgage, :provides => :json do
    return if not_registered?
    g = get_cached_game
    pl = g.find_player_by(logged_uname);
    return if pl.nil?

    data = params[:str].to_s
    cells = GameHelper.parse_cells(data,pl.id)
    PlayerManager.go_mortgage_cells(g, pl, cells)
    Monopwww::App.cache['game'+session[:gameid]] = g

    html = partial 'shared/player_cells', :object => g
    { player_cells: html}.to_json
  end

  get :unmortgage, :provides => :json do
    return if not_registered?
    g = get_cached_game
    pl = g.find_player_by(logged_uname);
    return if pl.nil?

    data = params[:str].to_s
    cells = GameHelper.parse_cells(data,pl.id)
    PlayerManager.go_unmortgage_cells(g, pl, cells)
    Monopwww::App.cache['game'+session[:gameid]] = g
    html = partial 'shared/player_cells', :object => g
    { player_cells: html}.to_json
  end

  get :build_houses, :provides => :json do
    return if not_registered?

    g = get_cached_game
    pl = g.find_player_by(logged_uname);
    return if pl.nil?

    data = params[:str].to_s
    cells = GameHelper.parse_cells(data,pl.id)
    PlayerManager.go_build_houses(g, pl, cells)
    Monopwww::App.cache['game'+session[:gameid]] = g

    html = partial 'shared/player_cells', :object => g
    { player_cells: html}.to_json
  end

  get :sell_houses, :provides => :json do
    return if not_registered?

    g = get_cached_game
    pl = g.find_player_by(logged_uname);
    return if pl.nil?

    data = params[:str].to_s
    cells = GameHelper.parse_cells(data,pl.id)
    PlayerManager.go_sell_houses(g, pl, cells)
    Monopwww::App.cache['game'+session[:gameid]] = g

    html = partial 'shared/player_cells', :object => g
    { player_cells: html}.to_json
  end

  get :trade, :provides => :json do
    return if not_registered?

    g = get_cached_game
    #return if !g.in_begin?

    p cmd = params[:str].to_s
    res = GameUI.init_trade(g, cmd, logged_uname)
    Monopwww::App.cache['game'+session[:gameid]] = g

    { result: res ? 'предложение создано' : 'не корректные данные' }.to_json
  end

  get :run_command, :provides => :json do
    return if not_registered?

    g = get_cached_game
    commnd = params[:cmd].to_s
    data = commnd.split(';')

    if commnd.start_with?('set-pos')
      g.players[data[1].to_i].pos = data[2].to_i
    elsif commnd.start_with?('set-money')
      g.players[data[1].to_i].money = data[2].to_i
    elsif commnd.start_with?('set-cell')
      g.cells[data[2].to_i].owner = data[1].to_i
      g.map.update_map
    elsif commnd.start_with?('show-ok')
      g.ui_show_ok_when_endround = data[1].to_i ==1
    elsif commnd.start_with?('begin')
      g.to_begin
    elsif commnd.start_with?('step')
      GameManager.update_game(g)
    elsif commnd.start_with?('auto')
      g.ui_show_ok_when_endround = false
      GameManager.update_game(g)
    elsif commnd.start_with?('police')
      g.to_begin
      g.curr.police=1
      g.curr.manual_roll =0
      g.curr.pos=10
    elsif commnd.start_with?('info')
      g.log "#{g.round} #{g.state} #{g.curr.name} show_ok:#{g.ui_show_ok_when_endround}"
    elsif commnd.start_with?('init-text')
      FileUtil.init_game_messages(g)
    elsif commnd.start_with?('init-random')
      FileUtil.init_chest_cards_from_file(g, root_path + "/data/chest_cards_#{g.lang}.txt")
    end

    Monopwww::App.cache['game'+session[:gameid]] = g

    { result: commnd }.to_json
  end
end
