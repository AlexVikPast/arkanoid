require 'tk'
require_relative './settings'

class Ball
  attr_accessor :x, :y, :dx, :dy, :r
  attr_reader :fill, :outline, :width, :setting
  
  def initialize(canvas)
    extend Settings
    @setting = settings

    @canvas = canvas
    
    @x, @y, @dx, @dy =  @setting.value("ball") || [200, 250, -3, -3]
    @r = @setting.value("ball_radius") || 10
    @fill =  @setting.value("ball_fill")
    @outline = @setting.value("ball_outline")

    @width = @setting.value("width")
    @height = @setting.value("height")

    @ball = TkcOval.new( 
      @canvas, @x-@r, @y-@r, @x+@r, @y+@r, :fill => @fill, :outline => @outline
    )
  end
  
  def move
    @x += @dx
    @y += @dy
    
    if @x <= 0 || @x >= @width
      @dx *= -1
    end
    
    if @y <= 0 || @y >= @height
      @dy *= -1
    end
    
    @canvas.coords(@ball, @x-@r, @y-@r, @x+@r, @y+@r)
  end

  def ball
    @ball
  end
end
