local Bullet = require("lib.bullet")
local Tools = require("lib.tools")

local Player = {}
Player.__index = Player

setmetatable(Player, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Player.new()
    self = setmetatable({}, Player)
    self.x = 256
    self.y = 256
    self.speed = 500
	self.angle = 0
	self.width = 55
	self.height = 60
    self.canShootTimerMax = 0.2
    self.canShootTimer = self.canShootTimerMax
    self.bullets = {}
    self.canShoot = true
    self.ships = love.graphics.newImage("gfx/ships.gif")
    self.qShip = love.graphics.newQuad(6, 6, 55, 60, self.ships:getWidth(), self.ships:getHeight())
  return self
end

function Player:update(dt)
    self.canShootTimer = self.canShootTimer - ( 1 * dt)
    if self.canShootTimer < 0 then
        self.canShoot = true
    end

    self.angle = Tools.findRotation(self.x, self.y, love.mouse.getX(), love.mouse.getY())
    self.x = self.x + (math.cos(self.angle) * self.speed) * dt
    self.y = self.y + (math.sin(self.angle) * self.speed) * dt  

    for i,bullet in ipairs(self.bullets) do
        print(i)
        -- bullet:update(dt)
    end
end

function Player:shoot(mouseX, mouseY)
    if self.canShoot == false then
        return
    end
    self.canShoot = false
    self.canShootTimer = self.canShootTimerMax
    return Bullet.new(self.x, self.y, mouseX, mouseY, love.math.random(10))
end

function Player:getX()
    return self.x
end

function Player:getY()
    return self.y
end

function Player:draw()
    love.graphics.draw(self.ships, self.qShip, player:getX(), player.y, player.angle-55, 1, 1, 55/2, 60/2)print("draw")

    for i,bullet in ipairs(self.bullets) do
        bullet:draw()
    end
end

return Player