
local PowerUp = class('PowerUp')

function PowerUp:initialize()
	x = -10
	y = love.math.random(0, love.window.getHeight())
	speed = 100
	sprite = love.graphics.newImage("gfx/powerup.png")
end

function PowerUp:update(dt)
 	x = x + (speed * dt)
    y = y + math.sin(x/19) * 5
end

function PowerUp:draw()
	love.graphics.draw(sprite, x, y)
end

function PowerUp:shoot(px, py, mouseX, mouseY)
	local newBullets = 
	{
		Bullet:new(px, py, mouseX, mouseY),
		Bullet:new(px, py, mouseX+10, mouseY+10)
   		
   	}
    return newBullets
end

function PowerUp:isPlayerCollision(player) 
	if x < player.x + player.width and 
           x + player.height > player.x and
	       y < player.y + player.width and
           y + player.height > player.y then
   		return true
   	else
   		return false
   	end
end

function PowerUp:isOutOfBounds()
 	if x < -10 or x > love.window.getWidth() + 10 then
	 	return true
	 else
	    return false
	end
end

return PowerUp