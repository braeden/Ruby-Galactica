require 'ray'
#Define Window Title
Ray.game "Asteroids", :size => [600, 700] do
  register { add_hook :quit, method(:exit!) }
  scene :square do
    #Create Ship and Define parmeters
    @ship = Ray::Polygon.new
    @ship.pos = [400,689]
    @ship.add_point([-8,10])
    @ship.add_point([8,10])
    @ship.add_point([0,-10])
    @ship.filled   = false
    @ship.outlined = true
    @bullets = []
    @level = 0
    @lives = 3
    @score = 0
    @aliens=[]
    @abullets=[]
    @al_vel= [rand(-2...2),0]
    i=0
    @aliens = 10.times.map do
      a =  Ray::Polygon.circle([0, 0], 10, Ray::Color.red)
      a.pos = [20+i, 400]
      i+=50
      a.filled = true
      a.outlined = true
      a.outline = Ray::Color.red
      a
    end
    @aliens += 10.times.map do
      a =  Ray::Polygon.circle([0, 0], 10, Ray::Color.red)
      a.pos = [20+i, 550]
      i+=50
      a.filled = true
      a.outlined = true
      a.outline = Ray::Color.red
      a
    end
    always do

      #Create ship movement
      if holding? key(:left)
        @ship.pos -= [3,0]
      end
      if holding? key(:right)
        @ship.pos += [3,0]
      end
      #Set ship boundries
      if @ship.pos.x > 592
        @ship.pos = [592, 689]
      elsif @ship.pos.x < 8
        @ship.pos = [8, 689]
      end
      #Shooting function
      if holding? key(:space)
        if rand(10) == 1
          @bullets += 1.times.map do
            b = Ray::Polygon.rectangle([0,0,2,2], Ray::Color.white)
            b.pos = [@ship.pos.x, @ship.pos.y]
            b
          end
        end
      end
      #Bullet movement

      if rand(100)==50
        @al_vel = [rand(-3...3), rand(-1...2)]
      end
      @aliens.each do |a|
        a.pos += @al_vel
        if a.pos.x > 600
          a.pos -= [600,0]
        elsif a.pos.x < 0
          a.pos += [600,0]
        end
        if a.pos.y < 200
          a.pos += [0, 5]
        elsif a.pos.y > 500
          a.pos -= [0, 5]
        end
        if a.pos.x == @ship.pos.x
          @abullets += 1.times.map do
            b = Ray::Polygon.rectangle([0,0,2,5], Ray::Color.red)
            b.pos = [a.pos.x, a.pos.y]
            b
          end
        end
        if a.pos.x+1 == @ship.pos.x
          @abullets += 1.times.map do
            b = Ray::Polygon.rectangle([0,0,2,5], Ray::Color.red)
            b.pos = [a.pos.x, a.pos.y]
            b
          end
        end
        if a.pos.x-1 == @ship.pos.x
          @abullets += 1.times.map do
            b = Ray::Polygon.rectangle([0,0,2,5], Ray::Color.red)
            b.pos = [a.pos.x, a.pos.y]
            b
          end
        end
      end

      @abullets.each do |a|
        a.pos += [0, 2]
        if a.pos.y > 800
          @abullets.delete(a)
        end
        if [@ship.pos.x, @ship.pos.y, 16, 20].to_rect.collide?([a.pos.x, a.pos.y, 2, 5])
          @abullets.delete(a)
          @lives -= 1
        end
      end
      @bullets.each do |b|
        b.pos -= [0,5]
        if b.pos.y > 800
          @bullets.delete(b)
        end
        @aliens.each do |a|
          if [a.pos.x, a.pos.y, 20, 20].to_rect.collide?([b.pos.x, b.pos.y, 2, 2])
            @aliens.delete(a)
            @bullets.delete(b)
            @score += 500

          end
        end

      end

    end
    render do |win|

      if @lives <= 0
        win.draw text("YOU LOST", :at => [180,180], :size => 60)
        win.draw text("Score:" + @score.to_s, :at => [0,0], :size => 20)
      elsif @score == 10000
        win.draw text("YOU WON", :at => [180,180], :size => 60)
        win.draw text("Score:" + @score.to_s, :at => [0,0], :size => 20)
      else
        win.draw text("Lives:" + @lives.to_s, :at => [0,0], :size => 20)
        win.draw text("Score:" + @score.to_s, :at => [100,0], :size => 20)
        win.draw @ship
        @bullets.each do |b|
          win.draw b
        end

        @aliens.each do |al|
          win.draw al
        end
        @abullets.each do |a|
          win.draw a
        end
      end
    end
  end
  scenes << :square
end

=begin


player hit
alien hit
lives
lose

alien spawn
score
=end
