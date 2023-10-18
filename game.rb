require 'tk'
require_relative './settings'
require_relative './ball'
require_relative './paddle'


class Game
  attr_accessor :speed, :point, :game_over, :life, :ball, :paddle
  attr_reader :width, :height, :setting, :name

  def initialize
    extend Settings

    @setting = settings

    @speed = @setting.value("speed")
    @width = @setting.value("width")
    @height = @setting.value("height")

    @name =  @setting.value("name")

    @point = @setting.value("point")
    @life = @setting.value("life") || 1
    @game_over = false

    @root = TkRoot.new
    
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
    @root.title = "#{@name}. point: #{@point}. count_life: #{@life}" if !game_over?
    @ball.move
    check_collision
    @root.after(100 - @speed) { animate }
  end
  
  def game_over?
    @game_over
  end

  def game_over
    @root.title = "Game Over. Total point: #@point"
    @game_over = true
    @ball.dx = 0
    @ball.dy = 0
    @canvas.itemconfigure @paddle.paddle, :state => 'hidden'
    @canvas.itemconfigure @ball.ball, :state => 'hidden'
  end

  def check_collision
    if !game_over?
      ball_bbox = @canvas.bbox(@ball.ball)
      paddle_bbox = @canvas.bbox(@paddle.paddle)
      
      if ball_bbox && paddle_bbox
        ball_x1, ball_y1, ball_x2, ball_y2 = ball_bbox
        paddle_x1, paddle_y1, paddle_x2, paddle_y2 = paddle_bbox
        
        if ball_y2 >= paddle_y1 && (paddle_x1..paddle_x2).include?((ball_x1 + ball_x2) / 2)
          @point += 1
          @ball.dy *= -1
        end

        if ball_y2 >= paddle_y1 && !(paddle_x1..paddle_x2).include?((ball_x1 + ball_x2) / 2)
          @life -= 1
          @ball.dy *= -1
          game_over if @life.zero?
        end
      end
    end
  end
end
