module GameHelper

  def self.parse_cells(data,pid)
    #data = params[:str].to_s
    pldata=data.split(';').select{ |d| d.start_with? "p#{pid}"  }.first
    cells = pldata.split('-').map { |c| c.to_i  }
  end
  def self.get_curr_game(gid)
    Monopwww::App.cache['game'+gid]
  end
  def self.set_curr_game(gid, g)
    Monopwww::App.cache['game'+gid] = g
  end
  def self.html_buttons(g, uname)
    #return "bot playing" if g.curr.bot? and !g.in_trade? and !g.in_auction? and !g.state_endround?

    case g.state
    when :BeginStep;     show_begin_round(g,uname)
    when :CanBuy;        show_buy_auc_html(g,uname)
    when :Auction;       show_auction_html(g, uname)
    when :Trade;         show_trade_offer(g, uname)
    when :CantPay;       "заложите или продайте что-нибудь "+show_endround_ok(g)
    when :NeedPay;       show_need_pay_html(g,uname)
    when :RandomCell,:MoveToCell;    "#{g.round_message}"+ show_endround_ok(g,uname)
    when :EndStep;       "#{g.round_message}" +show_endround_ok(g,uname)
    else
      g.state
    end
  end
  def self.show_log(g)
    r = g.round
    logs = g.logs.select{ |l| l.start_with?("[#{r}]")}
    logs.join("<br />")
  end

  def self.show_begin_round(g,uname)
    
    text =''
    if  g.is_manual_roll_mode
      my_player = g.find_player_by(uname)

      if my_player.manual_roll.nil? || my_player.manual_roll ==0
        text = " выберите число <br />" + html_text('PartManualRoll')
      else
        text = " вы выбрали #{my_player.manual_roll} <br />"
      end
    else
      if g.curr?(uname)
        text = "<br />" + html_text('ButtonRoll')
      else
        text = "<br />" + html_text('ButtonOK') if g.curr.bot?
      end
    end

    if g.curr?(uname)
      if  g.curr.police>0
        text = "вы можете заплатить $500, чтобы выйти сразу <br />#{html_text('ButtonPay')} <br />" + text
      elsif  g.curr.police==4
        text = "вы не вышли по дублю из тюрьмы, заплатите<br />#{html_text('ButtonPay')} <br />"
      end
    end

    "<br />[раунд #{g.round}] ходит #{g.curr.name}, "+text

  end

  def self.show_buy_auc_html(g, uname)
    if g.curr?(uname)
      "#{g.round_message} <br /><br /> вы можете купить #{g.curr_cell.name} <br />" + html_text('BuyOrAuc')
    else
      "#{g.round_message} <br /><br /> игрок может купить #{g.curr_cell.name} <br />"
    end
  end
  def self.show_endround_ok(g,uname)
    if g.curr?(uname) || g.curr.isbot
      " <br /><br />"+ html_text('ButtonOK')
    else
      ""
    end
  end
  def self.show_need_pay_html(g,uname)
    if g.curr?(uname)
      "#{g.round_message}<br />" + html_text('ButtonPay')
    else
      ""
    end
  end

  def self.show_trade_offer(g, uname)

    text = "#{g.curr_trade.from.name} надеется сделать обмен с #{g.curr_trade.to.name}, предлагает #{g.curr_trade.give_cells.map { |c| g.cells[c].name  }}"+
      " мечтает #{g.curr_trade.get_cells.map { |c| g.cells[c].name  }}"
    text += "<br /> согласны? <br />" + html_text('TradeYesNo')  if g.curr_trade.to.name == uname
    text

  end

  def self.show_auction_html(g, uname)
    pl = g.find_player_by(uname)
    return "" if pl.nil?

    auc = g.curr_auction
    pl_in_auc  = auc.auc_pls.include? pl.id

    if pl_in_auc
      html_text('HtmlAuction') % [auc.cell.name, auc.auc_pls, auc.cell.cost, auc.curr_bid, auc.next_bid] #if g.curr_auction.curr_pl.hum?
    else
      "последняя ставка $#{auc.curr_bid}"
    end
  end

  def self.html_text(key)
 
    doc = Nokogiri::XML(File.open(Padrino.root('/lib/gameui/ui.xml')))
    doc.css('text').each do |node|
      return node.css('ru').text.strip if node.attr('key') == key
    end
  end

  def self.show_logs(g)
    r = g.round
    logs = g.logs.select{ |l| l.start_with?("[#{r}]") or l.start_with?("[#{r-1}]") or l.start_with?("[#{r-2}]") }
  end

  def self.sim_game
    g = Game.new(Padrino.root('/lib/monop_lib/'))
    g.update_interval =0.01
    g.log_game_rounds =true

    g.add_player("vitek(b)",1)
    g.add_player("fedor(b)",1)

    g.start
    g
  end


  def self.player_images
    img = "<img src='/game/images/p%s.png' >"
    (0..3).to_a.map { |e|  img % e}
  end
  def self.colors
    ["#FF8080","LightBlue","LightGreen","Yellow","Gray"]
  end

  def self.GetPlayerColorRGB(p)
    colors[p.to_i]
  end

  def self.print_cell_info(cell)

    if cell.land?

      if !cell.owner.nil? && cell.mortg?
        return "MORTG"
      else
        return "#{cell.rent}"
      end

    end

    return ""

  end

  def self.info(g)
    res=[]
    res<<"<table>"
    img = "<img src='/game/images/p%s.png' >"

    g.players.each do |pl|
      money_str = pl.money.to_s.reverse.gsub(/...(?=.)/,'\& ').reverse
      pl_image = img % pl.id
      res<< "<tr><td>#{pl_image}</td> <td> <b>#{pl.name}</b> </td> <td><span style=\"color: red\">$ #{money_str}</span> </td></tr>"
    end

    res<<"</table>"
  end

end
