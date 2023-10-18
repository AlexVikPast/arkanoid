require 'tk'
require_relative './settings'


class Paddle
  attr_accessor :x, :dx, :y1, :y2
  attr_reader :outline, :fill, :offset, :width

  def initialize(canvas)
    extend Settings
    @setting = settings

    @canvas = canvas
    @x = @setting.value("paddle_x") 
    @dx = @setting.value("paddle_dx")
    @y1 = @setting.value("paddle_y1")
    @y2 = @setting.value("paddle_y2")
    @outline = @setting.value("paddle_outline")
    @fill = @setting.value("paddle_fill")
    @offset = @setting.value("paddle_offset")
    @width = @setting.value("width")

    @paddle = TkcRectangle.new(
    @canvas, @x-@dx, @y1, @x+@dx, @y2, :fill => @fill, :outline => @outline
    )
  end

  def move_left
    @x -= @offset
    @x = @dx if @x < @dx
    @canvas.coords(@paddle, @x-@dx, @y1, @x+@dx, @y2)
  end

  def move_right
    @x += @offset
    @x = @width - @offset if @x > @width - @offset
    @canvas.coords(@paddle, @x-@dx, @y1, @x+@dx, @y2)
  end

  def paddle
    @paddle
  end
end
