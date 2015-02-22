local Bullet = class('Bullet')

function Bullet:initialize(self, startX, startY, mouseX, mouseY)
  self.x = startX 
  self.y = startY
  self.width = 5
  self.height = 5
  self.speed = 100
  local angle = math.atan2((mouseY - startY), (mouseX - startX))
  self.dx = 100 * math.cos(angle)
  self.dy = 100 * math.sin(angle)
end

function Bullet:printXY()  
  print("x: " .. self.x)
  print("y: " .. self.y)
end

function Bullet:update(dt)
    self.x = self.x + (self.dx * dt)
    self.y = self.y + (self.dy * dt)
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
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Bullet