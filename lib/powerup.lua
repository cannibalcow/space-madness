
local PowerUp = class('PowerUp')

function PowerUp:initialize()
	level = 0
end

function PowerUp:shoot(px, py, mouseX, mouseY)
	if level == 0 then
	    return singleShot(px, py, mouseX, mouseY)
    elseif level == 1 then
		return dualShot(px, py, mouseX, mouseY)
	elseif level == 2 then
		return tripleShot(px, py, mouseX, mouseY)
	elseif level == 3 then
		return sixShot(px, py, mouseX, mouseY)
	end
end

function singleShot(px, py, mouseX, mouseY)
    local newBullet = {
    	Bullet:new(px, py, mouseX, mouseY)
	} 
   	return newBullet
end

function dualShot(px, py, mouseX, mouseY)
	local newBullets = {
		Bullet:new(px, py, mouseX, mouseY),
		Bullet:new(px, py, mouseX+10, mouseY+10)
   		
   	}
   	return newBullets
end

function tripleShot(px, py, mouseX, mouseY)
	local newBullets = {
		Bullet:new(px, py, mouseX, mouseY),
		Bullet:new(px, py, mouseX+10, mouseY+10),
		Bullet:new(px, py, mouseX+20, mouseY+20)
	}
	return newBullets
end

function sixShot(px, py, mouseX, mouseY)
	local newBullets = {
		Bullet:new(px, py, mouseX, mouseY),
		Bullet:new(px, py, mouseX+10, mouseY+10),
		Bullet:new(px, py, mouseX+20, mouseY+20),
		Bullet:new(px, py, mouseX+30, mouseY+30),
		Bullet:new(px, py, mouseX+40, mouseY+40),
		Bullet:new(px, py, mouseX+50, mouseY+50)
	}
	return newBullets
end

function PowerUp:increaseLevel()
	if level >= 3 then
		return
	end
	level = level + 1
end

function PowerUp:getPowerUpLevel()
	return level
end

function PowerUp:setLevel(lvl)
	level = lvl
end

return PowerUp