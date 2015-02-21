local Tools = {}

function findRotation(x1 , y1, x2, y2)
   return math.atan2(y2 - y1, x2 - x1)
end

Tools.findRotation = findRotation

return Tools