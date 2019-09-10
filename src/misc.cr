module LibMisc
  class Map
    property xsize, ysize : Int32
    property tiles
    def initialize(@xsize : Int32, @ysize : Int32)
      @tiles = {} of Point => Entity
      (0..@xsize).each do |x|
        (0..@ysize).each do |y|
          point = Point.new x, y
          entity = Entity.new "Tile", point, self
          @tiles.merge!({point => entity})
        end
      end
    end
  end

  class Point
    property x, y : Int32
    def initialize(x : Int32, y : Int32)
      @x = x
      @y = y
    end

    def in_bounds?(map : Map) : Bool
      if @x <= map.xsize && @y <= map.ysize
        true
      else 
        false
      end
    end

    def_hash @x, @y
  end

  class Entity
    @x = 0
    @y = 0
    def initialize(name : String, coord : LibMisc::Point, map : LibMisc::Map)
      if coord.in_bounds? map 
        @name = name
        @x = coord.x
        @y = coord.y
      else
        raise "Can't create entity outside of map bounds!"
      end
    end
  end
end
