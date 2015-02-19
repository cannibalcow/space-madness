bullets = {}
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

width = 1920
height = 1280

score = 0

monsters = {}
monsterSpawnFrequence = 0.2
monsterTimer = monsterSpawnFrequence
state = "alive"
deaths = 0
bulletSpeed = 900
bg = nil

function love.load()
    love.window.setFullscreen(false)
    love.mouse.setVisible(true)
    player = {
        x = 256, 
        y = 256,
        radius = 15,
        speed = 500,
        angle = 0,
        width = 55,
        height = 60
    }

    bg = love.graphics.newImage("gfx/bg.jpg")
    ships = love.graphics.newImage("gfx/ships.gif")
    qShip = love.graphics.newQuad(6, 6, 55, 60, ships:getWidth(), ships:getHeight())
    qEnemy = love.graphics.newQuad(130, 130, 55, 55, ships:getWidth(), ships:getHeight())
    crossHair = love.graphics.newImage("gfx/crosshair.png")
    
    -- Cursor
    cursor = love.mouse.newCursor("gfx/crosshair.png", 0, 0)
    love.mouse.setCursor(cursor)

    -- BG music
    bgMusic = love.audio.newSource("sfx/Azureflux_-_05_-_Expedition.mp3")
    bgMusic:play()
end

function love.draw()
 -- Draw background

    if state == "paused" then
        love.graphics.print("PAUSE!", love.window.getWidth() / 2, love.window.getHeight() / 2)
        return
    end

    if state == "player_dead" then
        love.graphics.print("YOU DEAD! YOU NO GOOD! YOU SCORE: " .. score , love.window.getWidth() / 2 - 100, love.window.getHeight() / 2)
        love.graphics.print("CLICK MOUSE TO PLAY AGAIN!" , love.window.getWidth() / 2 - 100, love.window.getHeight() / 2 + 25)
        return 
    end

       love.graphics.draw(bg, 0, 0)


    -- Draw info
    love.graphics.print("x: " .. player.x .. " y: ".. player.y , 50, 50)
    love.graphics.print("Score: " .. score, 25, 25)    
    love.graphics.print("Deaths: " .. deaths, 25, 35)
    
    -- Draw player
    love.graphics.draw(ships, qShip, player.x, player.y, player.angle-55, 1, 1, 55/2, 60/2)

    -- Draw bullets
    for i, bullet in ipairs(bullets) do
        -- love.graphics.setColor(255, 165, 0)
        love.graphics.rectangle("fill", bullet.x, bullet.y, 5, 5)
    end

    -- Draw monster
    for i, monster in ipairs(monsters) do
        love.graphics.draw(ships, qEnemy, monster.x, monster.y)
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

    if state == "paused" or state == "player_dead" then
        return
    end

    -- Check shoot timer
    canShootTimer = canShootTimer - ( 1 * dt)
    if canShootTimer < 0 then
        canShoot = true
    end

    -- rotate and move player
    player.angle = findRotation(player.x, player.y, love.mouse.getX(), love.mouse.getY())
    player.x = player.x + (math.cos(player.angle) * player.speed) * dt
    player.y = player.y + (math.sin(player.angle) * player.speed) * dt  

    -- Move bullets
    for i,bullet in ipairs(bullets) do
        bullet.x = bullet.x + (bullet.dx * dt)
        bullet.y = bullet.y + (bullet.dy * dt)
    end

    -- Bullet collision TODO
    for x, bullet in ipairs(bullets) do
        for i, monster in ipairs(monsters) do
            if bullet.x < monster.x + monster.width and 
               bullet.x + bullet.width > monster.x and
               bullet.y < monster.y + monster.height and
               bullet.y + bullet.height > monster.y then
               
               monster.state = "dead"
               table.remove(bullets, x)
               score = score + 1
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
            if monster.direction == "fromLeft" then
                monster.x = monster.x + (125 * dt)
                monster.y = monster.y + math.sin(monster.x/20) * 10
            else
                monster.x = monster.x - (125 * dt)
                monster.y = monster.y + math.sin(monster.x/20) * 10
            end
        else
            monster.y = monster.y + (800 * dt)
            monster.x = monster.x + math.sin(monster.y/20) * 10;
        end

        if monster.x < -10 or monster.x > love.window.getWidth() + 10 then
            print("killing monster ".. i)
            table.remove(monsters, i)
        end
    end

    -- player monster collision detection
    for i, monster in ipairs(monsters) do
        if monster.state == "alive" then
            if monster.x < player.x + player.radius and 
               monster.x + 55 > player.x and
               monster.y < player.y + player.radius and
               monster.y + 55 > player.y then
               state = "player_dead"
               deaths = deaths + 1
           end
       end
    end
end

function findRotation(x1 , y1, x2, y2)
   return math.atan2(y2 - y1, x2 - x1)
end

function love.keypressed(key, isrepeat)
    if key == "p" then
        if state == "paused" then
            state = "play"
        else
            state = "paused"
        end
    end
end

function love.mousepressed(x, y, button)
    if state == "player_dead" then
        state = "play"
        score = 0
        for i in pairs(monsters) do
            monsters[i] = nil
        end
    end
    -- shoot
    shoot(x, y)
end

function shoot(x, y) 
    local startX = player.x + player.width / 2
    local startY = player.y + player.height / 2
    local mouseX = x
    local mouseY = y
    
    local angle = math.atan2((mouseY - startY), (mouseX - startX))
    
    local bulletDx = bulletSpeed * math.cos(angle)
    local bulletDy = bulletSpeed * math.sin(angle)
    
    table.insert(bullets, {
        x = startX, 
        y = startY, 
        dx = bulletDx, 
        dy = bulletDy,
        width = 5,
        height = 5
    })
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
    randDir = love.math.random(1, 2)
    if randDir == 1 then
        randX = 0
        dir = "fromLeft"
    else
        randX = love.window.getWidth()
        dir = "fromRight"
    end

    newMonster = {
        x = randX,
        y = love.math.random(0, love.window.getHeight()),
        r = love.math.random(0, 255),
        g = love.math.random(0, 255),
        b = love.math.random(0, 255),
        width = 55,
        height = 55,
        state = "alive",
        direction = dir
    }
    table.insert(monsters, newMonster)
end
