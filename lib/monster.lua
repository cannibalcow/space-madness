local Monster = class('Monster')

function Monster:initialize()
	self.randDir = love.math.random(1, 2)
    if self.randDir == 1 then
        self.randX = 0
        self.direction = "fromLeft"
    else
        self.randX = love.window.getWidth()
	    self.direction = "fromRight"
    end

	self.x = self.randX
	self.y = love.math.random(0, love.window.getHeight())
	self.r = love.math.random(0, 255)
	self.g = love.math.random(0, 255)
	self.b = love.math.random(0, 255)
	self.width = 55
	self.height = 55
	self.state = "alive"
	self.qEnemy = love.graphics.newQuad(130, 130, 55, 55, ships:getWidth(), ships:getHeight())
end

function Monster:update(dt) 
	if self.state == "alive" then
        if self.direction == "fromLeft" then
            self.x = self.x + (125 * dt)
            self.y = self.y + math.sin(self.x/20) * 10
        else
            self.x = self.x - (125 * dt)
            self.y = self.y + math.sin(self.x/20) * 10
        end
    else
        self.y = self.y + (800 * dt)
        self.x = self.x + math.sin(self.y/20) * 10;
    end
end

function Monster:isOutOfBounds()
	 if self.x < -10 or self.x > love.window.getWidth() + 10 then
	 	return true
	 else
	     return false
	end
end

function Monster:setDead()
	self.state = "dead"
end	

function Monster:draw()
	love.graphics.draw(ships, qEnemy, self.x, self.y)
end

function Monster:isPlayerCollision(player)
	-- todo  fix better hit detection
	if self.state == "alive" then
		if self.x < player.x + player.width and 
           self.x + player.height > player.x and
	       self.y < player.y + player.width and
           self.y + player.height > player.y then
           return true
       end
	else
		return false
	end
end

return Monster