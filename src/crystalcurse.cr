require "ncurses"
require "./misc.cr"
require "./entity.cr"
require "./ui.cr"

ui = CyrseUI::UI.new
# NCurses.start
# NCurses.cbreak
# NCurses.no_echo
# NCurses.keypad true
NCurses.mouse_mask NCurses::Mouse::AllEvents
NCurses.set_cursor NCurses::Cursor::Invisible
run = true
XSIZE = NCurses.height
YSIZE = NCurses.width

ui.add_window(:main, XSIZE, YSIZE, 0, 0)
ui.window(:main) do | w |
  w.enable_border
  w.enable_title
  w.enable_status
  w.window.keypad true
end

LEVEL = LibMisc::Map.new 4, 6 #(XSIZE, YSIZE)
PLAYER = LibMisc::Entity.new "Player", 2, 2, LEVEL #LibMisc::Point.new(2, 2)

iter = 0
lineposx = XSIZE//2
lineposy = YSIZE//2
bg = 32
while run
  #  ui.window(:main).set_title " #{NCurses.height}, #{NCurses.width} "
  ui.window(:main).refresh do | win |
    win.add_horizontal_line(win.max_x, {lineposx, 0})
    win.add_vertical_line(win.max_y, {0, lineposy})
    win.print "#{lineposx} #{lineposy}", lineposx-1, lineposy+1
    win.print("#{win.get_background}" , 4, 4)
  end
  
  input = ui.window(:main).get_input
  CyrseUI::Log.debug "#{input.class.to_s} #{input.to_s}"
  ui.window(:main).window.get_char do |ch|
    case ch
    when 'q'
      run = false
      break
    when 'w'
      lineposx -= 1
      break
    when 's'
      lineposx += 1
      break
    when 'a'
      lineposy -= 1
      break
    when 'd'
      lineposy += 1
      break
    when 'p'
      break
    when 'b'
      ui.window(:main).enable_border false
      break
    when 'n'
      ui.window(:main).enable_border
      break
    when 'c'
      pp PLAYER
      break
    else
      if ch == NCurses::Key::Mouse
        mouse = NCurses.get_mouse
        ch_str = mouse.to_s
      else
        ch_str = ch.to_s
      end
      ch_class = ch.class.to_s
      str = " #{ch_class}, #{ch_str} "
      ui.window(:main).set_status str
      break
    end
  end
  iter += 1
end


NCurses.end
