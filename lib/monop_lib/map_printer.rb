require_relative "utils"
require_relative "game"
require_relative  'game_manager'
require_relative "player"
require_relative "player_steps"

class MapPrinter

  MARKS = ['*','+','%','#']
  def initialize
    clean

  end

  def draw(g, as_text = false)
    clean
    out=[]

    out<< "--map"

    g.players.each do |p|
      r,c = get_cell(p.pos)
      @map[r+1][c+p.id] = MARKS[p.id] #draw_player(p.id)
    end

    c=60
    r=1
    cells = []
    g.cells.select{|cc| cc.land?}.group_by(&:group).sort_by{|k,v| k}.each do |k,v|
      group_row=""
      v.each do |cl|
        pl = cl.owner ? draw_player(cl.owner) : " "
        group_row += "#{pl}#{cl.name.strip.ljust(2, ' ')}_#{cl.rent} "
      end
      cells << group_row
      cells << "".ljust(30, '-')
    end

    ## draw cells info
    for i in 0..@map.size

      l = @map[i] if i<@map.size
      if i<cells.size
        out<< l #l.gsub("\n","").ljust(60, ' ') + cells[i]
      else
        out<< l
      end
    end

    out
  end

  def self.draw_telegram_map(g)
    pos = g.curr.pos

    out=[]
    part= case pos
    when 0..5; File.readlines("data/map1.txt")
    when 6..15; File.readlines("data/map2.txt")
    when 15..25; File.readlines("data/map3.txt")
    when 25..35; File.readlines("data/map4.txt")
    when 36..40; File.readlines("data/map1.txt")

    end
    pp = "c#{pos}"

    if part 
      part.join("").sub(pp, "my")
    else
      pp
    end
  end


  def clean
    @map = File.readlines("data/map.txt")
  end

  def get_cell(p)
    case p
    when 0..10
      r,c = 1 , 4*(p+1)
    when 11..20
      r,c = 2*p-19 , 44
    when 21..30
      r,c = 21, 4*(31-p)
    when 31..39
      r,c = 21-(p-30)*2 , 4
    else

    end

  end

  def draw_player(pl)
    #@marks[pl]
    case pl
    when 0
      " ".bg_red
    when 1
      " ".bg_blue
    when 2
      " ".bg_green
    end
  end

end

class String
  def black;          "\033[30m#{self}\033[0m" end

  def red;            "\033[31m#{self}\033[0m" end

  def green;          "\033[32m#{self}\033[0m" end

  def  brown;         "\033[33m#{self}\033[0m" end

  def blue;           "\033[34m#{self}\033[0m" end

  def magenta;        "\033[35m#{self}\033[0m" end

  def cyan;           "\033[36m#{self}\033[0m" end

  def gray;           "\033[37m#{self}\033[0m" end

  def bg_black;       "\033[40m#{self}\0330m"  end

  def bg_red;         "\033[41m#{self}\033[0m" end

  def bg_green;       "\033[42m#{self}\033[0m" end

  def bg_brown;       "\033[43m#{self}\033[0m" end

  def bg_blue;        "\033[44m#{self}\033[0m" end

  def bg_magenta;     "\033[45m#{self}\033[0m" end

  def bg_cyan;        "\033[46m#{self}\033[0m" end

  def bg_gray;        "\033[47m#{self}\033[0m" end

  def bold;           "\033[1m#{self}\033[22m" end

  def reverse_color;  "\033[7m#{self}\033[27m" end
end
