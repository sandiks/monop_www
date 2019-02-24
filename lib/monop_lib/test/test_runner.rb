require_relative "test"
require_relative "map_printer"


#p MapPrinter.draw_telegram_map(1,5)

#---------------
#test_make_step_on_manual_mode

#---------------
#test_random

#---------------
#test_police_exit

#---------------
#test_build_houses

=begin

--------------------
sum = 0.7*g.player_assets(0,false)
BBHouses.build_houses(g,sum)
g.info
--------------------
myGroupsWithHouses = BBHouses.get_groups_where_need_build_houses(g,p.id)
p myGroupsWithHouses.map{ |gh|
arr = BotActionsWhenBuy.mygroups_with_max_housecount(gh[0], gh[1])
mf = arr.detect{|f| f[0] > available_money }
puts "#{mf}"
mf.nil? ? -1 : mf[1]
}.min
=end

#---------------
#test_trade

#p BotBrainTrade.get_valid_trades(g,p)
#BotBrainTrade.try_do_trade(g)

#---------------
#parse_trade_cmd
