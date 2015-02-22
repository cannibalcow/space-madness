-- local class = require 'lib.middleclass'
local Bullet = class('Bullet')
local bself = {}
function Bullet.initialize(self, startX, startY, mouseX, mouseY)
  bself.x = startX 
  bself.y = startY
  bself.width = 5
  bself.height = 5
  bself.speed = 900
  local angle = math.atan2((mouseY - startY), (mouseX - startX))
  bself.dx = 900 * math.cos(angle)
  bself.dy = 900 * math.sin(angle)
end

function Bullet:update(dt)
  bself.x = bself.x + (bself.dx * dt)
  bself.y = bself.y + (bself.dy * dt)
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
  love.graphics.rectangle("fill", bself.x, bself.y, bself.width, bself.height)
end

return Bullet