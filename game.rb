require 'tk'
require_relative './share_setting'


class Ball
  attr_accessor :x, :y, :dx, :dy, :r
  attr_reader :fill, :outline, :width, :setting
  
  def initialize(canvas)
    extend ShareSetting
    @setting = setting

    @canvas = canvas
    
    @x, @y, @dx, @dy = @setting.value("ball")
    @r = @setting.value("ball_radius")
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

class Paddle
  attr_accessor :x, :dx, :y1, :y2
  attr_reader :outline, :fill, :offset, :width
  
  def initialize(canvas)
    extend ShareSetting
    @setting = setting

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

class Game
  attr_accessor :speed
  attr_reader :width, :height, :setting, :name

  def initialize
    extend ShareSetting
    @setting = setting
    @speed = @setting.value("speed")
    @width = @setting.value("width")
    @height = @setting.value("height")
    @name =  @setting.value("name")

    @root = TkRoot.new { title @name }
    
    @canvas = TkCanvas.new(@root, width: @width, height: @height)
    
    @ball = Ball.new(@canvas)
    @paddle = Paddle.new(@canvas)

    @canvas.pack

    @root.bind('KeyPress') do |event|
        case event.keysym
        when 'a' then @paddle.move_left
        when 'd' then @paddle.move_right
        end
    end
    
    animate
  end
  
  def animate
    @ball.move
    check_collision
    @root.after(100 - @speed) { animate }
  end
  
  def check_collision
    ball_bbox = @canvas.bbox(@ball.ball)
    paddle_bbox = @canvas.bbox(@paddle.paddle)
    
    if ball_bbox && paddle_bbox
      ball_x1, ball_y1, ball_x2, ball_y2 = ball_bbox
      paddle_x1, paddle_y1, paddle_x2, paddle_y2 = paddle_bbox
      
      if ball_y2 >= paddle_y1 && (paddle_x1..paddle_x2).include?((ball_x1 + ball_x2) / 2)
        @ball.dy *= -1
      end
    end
  end
end

Game.new

Tk.mainloop
