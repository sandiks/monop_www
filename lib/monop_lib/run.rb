require_relative "game"
require_relative "map_printer"
require_relative "game_control"


def  run_console_game
  puts "---run console game.rb"


  g = Game.new(File.dirname(__FILE__), "en")

  g.add_player("human",0)
  g.add_player("jon_bot",1)

  g.update_interval  = 0.1
  g.ui_show_ok_when_endround  = true
  #g.is_manual_roll_mode = true
  g.isconsole = true

  #Thread.new { g.start }
  g.start

  sleep(1)

  #pr = MapPrinter.new

  my_name = 'human'

  s="start"

  loop do
    #GameUI.player_houses_info(g).each { |e| puts e  }

    #pr.draw(g)

    #p g.round_message.gsub("<br/>",", ").gsub("<br />",", ")

    logs = g.logs.select{ |l| l.start_with?("[#{g.round}]") }
    #logs = g.logs.select{ |l| l.start_with?("[#{g.round-1}]") } if logs.size ==0

    p logs if !logs.empty?

    text =  GameUI.show_game_state_en(g,my_name)

    p "#{text}" if g.state != :EndStep

    s = gets
    break if s.strip =="q"

    GameUI.process_command(g, s.strip, my_name)

  end
end
#run_console_game

def run_sim
  puts "---run game simulator"

  g = Game.new(File.dirname(__FILE__))

  g.update_interval =1
  #g.log_to_console =false
  g.ui_show_ok_when_endround = false

  g.add_player("kilk",1)
  g.add_player("fedor(b)",1)
  begin
    g.start
    g.check_roll_and_make_step
    #break if g.round>200 || g.finished?

    path = '/tmp/monop.log'

    File.open(path, 'w') do |file|
      g.xlogs.each{|l| file.puts l }
    end

    #system "mousepad "+ path
    puts g.xlogs
    p GameUI.player_houses_info(g)

    puts "finished #{g.state}"
  rescue SystemStackError
    puts $!
    puts caller[0..100]
  end

end
#run_sim
