require "ncurses"
require "logger"
module CyrseUI
  NULL_CHAR = '\u0000'
  Log = Logger.new(File.new("/home/johnd/crystalcurse/window.log", "w"))

  class Window
    getter window : NCurses::Window
    def initialize(name : String, xsize : Int, ysize : Int, x : Int, y : Int)
      @window = NCurses::Window.new(xsize, ysize, x, y)
      @title_enabled = false
      @title = "#{name}"
      @status_enabled = false
      @status = "#{xsize}, #{ysize}"
      @border_enabled = false
      @border_style = NULL_CHAR
    end

    def delete
      @window.clear
      @window.delete_window
    end
    
    def enable_border(bool = true)
      @border_enabled = bool
    end
    
    def border_enabled?
      @border_enabled
    end

    def set_border(c = NULL_CHAR)
      @border_style = c
    end

    def enable_title(bool = true)
      @title_enabled = bool
    end

    def title_enabled?
      @title_enabled
    end

    def set_title(s : String)
      @title = s
    end

    def enable_status(bool = true)
      @status_enabled = bool
    end

    def status_enabled?
      @status_enabled
    end

    def set_status(s : String)
      @status = s
    end

    def move
      
    end

    def refresh(&block)
      ysize = @window.max_x
      xsize = @window.max_y
      Log.info "border: #{@border_style.to_s} #{border_enabled?} title: #{@title.to_s} #{title_enabled?} status: #{@status} #{status_enabled?}", "window"
      Log.info "x here #{xsize.to_s} y here #{ysize.to_s} forom curses x #{NCurses.height} from curses y  #{NCurses.width}", "window"
      @window.clear
      if border_enabled?
        @window.box(@border_style, @border_style)
      end
      if title_enabled?
        @window.print(@title, 0, ysize/2 - @title.size/2)
      end
      if status_enabled?
        @window.print(@status, xsize-1, ysize/2 - @status.size/2)
      end
      yield window
      
      @window.refresh
    end
    
    def ysize
      @window.max_y
    end

    def xsize
      @window.max_x
    end

  end

  class UI
    
    def initialize 
      NCurses.start
      NCurses.cbreak
      NCurses.no_echo
      @windows = {} of Symbol => Window
    end

    def add_window(name : Symbol, xsize : Int, ysize : Int, x : Int, y : Int)
      @windows[name] = Window.new(name.to_s, xsize, ysize, x, y)
    end

    def window(name : Symbol)
      return @windows[name]
    end
    
    def window(name : Symbol, &block : Window -> Bool | Nil)
      yield @windows[name]
    end

    def remove_window(name : Symbol)
      @windows[name].delete
    end

    def refresh
      @windows.each { |w| w.refresh }
    end

  end
end
