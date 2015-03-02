local Bullet = class('Bullet')

function Bullet:initialize(startX, startY, mouseX, mouseY)
  self.x = startX 
  self.y = startY
  self.width = 5
  self.height = 5
  self.speed = 666
  local angle = math.atan2((mouseY - startY), (mouseX - startX))
  self.dx = self.speed * math.cos(angle)
  self.dy = self.speed * math.sin(angle)
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
  if monster.state ~= "alive" then
    return false
  end
  
  if self.x < monster.x + monster.width and 
     self.x + self.width > monster.x and
     self.y < monster.y + monster.height and
     self.y + self.height > monster.y then
     return true
   else
       return false
   end
end 

function Bullet:isOutOfBounds()
    local h = love.window.getHeight()
    local w = love.window.getWidth()

    if self.x < -1 or self.x > w + 1 or self.y < -1 or self.y > h then
      return true
    else
      return false
    end
end

function Bullet:draw()
  love.graphics.circle("line", self.x, self.y, 8, 2)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Bullet