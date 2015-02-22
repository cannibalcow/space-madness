local Monster = class('Monster')

function Monster:initialize()
	self.randDir = love.math.random(1, 2)
    if self.randDir == 1 then
        self.randX = 0
        self.dir = "fromLeft"
    else
        self.randX = love.window.getWidth()
        self.dir = "fromRight"
    end

	self.x = self.randX
	self.y = love.math.random(0, love.window.getHeight())
	self.r = love.math.random(0, 255)
	self.g = love.math.random(0, 255)
	self.b = love.math.random(0, 255)
	self.width = 55
	self.height = 55
	self.state = "alive"
	self.direction = self.dir
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

    if self.x < -10 or self.x > love.window.getWidth() + 10 then
        print("killing self ".. i)
        table.remove(monsters, i)
    end
end

function Monster:draw()
	love.graphics.draw(ships, qEnemy, monster.x, monster.y)
end

return Monster