local Bullet = {}
Bullet.__index = Bullet

setmetatable(Bullet, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Bullet.new(startX, startY, mouseX, mouseY)
  this = setmetatable({}, Bullet)
  this.x = startX 
  this.y = startY
  this.width = 5
  this.height = 5
  this.speed = 900
  local angle = math.atan2((mouseY - startY), (mouseX - startX))
  this.dx = 900 * math.cos(angle)
  this.dy = 900 * math.sin(angle)
  print(table.concat(this))
  return this
end

function Bullet:getX()
  return this.x
end

function Bullet:update(dt)
  this.x = this.x + (this.dx * dt)
  this.y = this.y + (this.dy * dt)
end

function Bullet:isMonsterCollition(monster)
  if bullet.x < monster.x + monster.width and 
     bullet.x + bullet.width > monster.x and
     bullet.y < monster.y + monster.height and
     bullet.y + bullet.height > monster.y then
     return true
   else
       return false
   end
end 

function Bullet:draw()
  love.graphics.rectangle("fill", this.x, this.y, 5, 5)
end

return Bullet