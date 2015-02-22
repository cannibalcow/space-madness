
local Player = class('Player')

function Player:initialize()
    self.x = 256
    self.y = 256
    self.speed = 500
    self.angle = 0
    self.width = 55
    self.height = 60
    self.canShootTimerMax = 0.2
    self.canShootTimer = 0.2
    self.canShoot = true
    self.ships = love.graphics.newImage("gfx/ships.gif")
    self.qShip = love.graphics.newQuad(6, 6, 55, 60, self.ships:getWidth(), self.ships:getHeight())
end

function Player:update(dt)
    if self.canShootTimer == nil  then
        print("Can shoot timer null")
        return
    end
    
    self.canShootTimer = self.canShootTimer - ( 1 * dt)
    if self.canShootTimer < 0 then
        self.canShoot = true
    end

    self.angle = Tools.findRotation(self.x, self.y, love.mouse.getX(), love.mouse.getY())
    self.x = self.x + (math.cos(self.angle) * self.speed) * dt
    self.y = self.y + (math.sin(self.angle) * self.speed) * dt  
end

function Player:shoot(mouseX, mouseY)
    if self.canShoot == false then
        return
    end

    self.canShoot = false
    self.canShootTimer = self.canShootTimerMax

    local newBullet = Bullet:new(self.x, self.y, mouseX, mouseY)
    return newBullet
end


function Player:getX()
    return self.x
end

function Player:getY()
    return self.y
end

function Player:draw()
    love.graphics.draw(self.ships, self.qShip, self.x, self.y, self.angle-55, 1, 1, 55/2, 60/2)
end

return Player
