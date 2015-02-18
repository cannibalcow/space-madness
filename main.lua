bullets = {}
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

width = 1280
height = 1024

score = 0

monsters = {}
monsterSpawnFrequence = 0.5
monsterTimer = monsterSpawnFrequence
state = "alive"

function love.load()
    love.window.setFullscreen(false)
    love.mouse.setVisible(false)
    player = {
        x = 256, 
        y = 256,
        radius = 15
    }
end

function love.draw()
    love.graphics.print("x: " .. player.x .. " y: ".. player.y , 50, 50)
    love.graphics.print("Score: " .. score, 25, 25)    

    -- Draw player
    love.graphics.setColor(255, 0, 0);
    love.graphics.circle("line", player.x, player.y, player.radius, 6)
    love.graphics.circle("line", player.x, player.y, 2, 6)
    love.graphics.point(player.x, player.y)

    -- Draw bullets
    for i, bullet in ipairs(bullets) do
        love.graphics.setColor(255, 165, 0)
        love.graphics.rectangle("fill", bullet.x, bullet.y, 5, 5)
    end

    -- Draw monster
    for i, monster in ipairs(monsters) do
        love.graphics.setColor(monster.r, monster.g, monster.b)
        love.graphics.rectangle("line", monster.x, monster.y, monster.width, monster.height)
    end            

    -- Reset color
    love.graphics.setColor(255,255,255)
    love.graphics.print(state, 100, 100)        

end

function love.update(dt)
    -- Exit
    if love.keyboard.isDown("escape") then
        love.event.push('quit')
    end

    -- Check shoot timer
    canShootTimer = canShootTimer - ( 1 * dt)
    if canShootTimer < 0 then
        canShoot = true
    end

    -- Move bullets
    for i, bullet in ipairs(bullets) do
        if bullet.direction == "l" then
            bullet.x = bullet.x - (250 * dt)
        else
            bullet.x = bullet.x + (250 * dt)
        end

        if bullet.x > width or bullet.x < 0 then
            table.remove(bullets, i)
        end
    end

    -- Bullet collision
    for x, bullet in ipairs(bullets) do
        for i, monster in ipairs(monsters) do
            if bullet.x < monster.x + monster.width and 
               bullet.x + bullet.width > monster.x and
               bullet.y < monster.y + monster.height and
               bullet.y + bullet.height > monster.y then
               
               monster.state = "dead"
               table.remove(bullets, x)
               score = score + 1
               state = "bang"
           end
       end
    end

    -- spawn monster
    if monsterReady(dt) then
        spawnMonster()
    end

    -- move monster
    for i, monster in ipairs(monsters) do
        if monster.state == "alive" then
            monster.x = monster.x + (100 * dt)
            monster.y = monster.y + math.sin(monster.x/20) * 10;
        else
            monster.y = monster.y + (400 * dt)
            monster.x = monster.x + math.sin(monster.y/20) * 10;
        end

        if monster.x > love.window.getHeight() or monster.y < 0 then
            print("killing monster ".. i)
            table.remove(monsters, i)
        end
    end

    -- player monster collision detection
    for i, monster in ipairs(monsters) do
        if monster.state == "alive" then
            if monster.x < player.x + player.radius and 
               monster.x + 15 > player.x and
               monster.y < player.y + player.radius and
               monster.y + 15 > player.y then
               state = "dead"
           end
       end
    end
end

function love.mousemoved(x, y, dx, dy)
    player.y = y
    player.x = x
end

function love.mousepressed(x, y, button)
    state = "alive"
    shoot(button)
end

function shoot(direction) 
    newBullet = { 
        x = player.x, 
        y = player.y - 1, 
        direction = direction,
        width = 5,
        height = 5
    }
    table.insert(bullets, newBullet)
    canShoot = false
    canShootTimer = canShootTimerMax
end 

function monsterReady(dt) 
    monsterTimer = monsterTimer - ( 1 * dt) 
    if monsterTimer < 0 then
        monsterTimer = monsterSpawnFrequence
        return true
    end
end

function spawnMonster() 
    newMonster = {
        x = 0,
        y = love.math.random(0, love.window.getHeight()),
        r = love.math.random(0, 255),
        g = love.math.random(0, 255),
        b = love.math.random(0, 255),
        width = 15,
        height = 15,
        state = "alive"
    }
    table.insert(monsters, newMonster)
end