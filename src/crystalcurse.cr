require "ncurses"
require "./misc.cr"
require "./entity.cr"

NCurses.start
NCurses.cbreak
NCurses.no_echo
NCurses.mouse_mask NCurses::Mouse::AllEvents
run = true
XSIZE = NCurses.height
YSIZE = NCurses.width
win = NCurses::Window.new(XSIZE, YSIZE, 0, 0)

LEVEL = LibMisc::Map.new 4, 6 #(XSIZE, YSIZE)
PLAYER = Entity.new "Player", LibMisc::Point.new(x/2, y/2), LEVEL

iter = 0
while run
  win.clear
  LEVEL.tiles.each do |k, v| 
    win.print "#{k}\n"
    win.refresh
  end
  win.refresh

  win.get_char do |ch|
    case ch
    when 'q'
      run = false
      break
    when 'n'
      break
    else
      win.print "#{ch.to_s}"
      win.refresh
    end
    end
  iter += 1
end


NCurses.end
