class = require 'lib.middleclass'
Tools = require("lib.tools")
Bullet = require("lib.bullet")
local Player = require("lib.player")
local Monster = require("lib.monster")

bullets = {}
monsters = {}

width = 1920
height = 1280

score = 0
deaths = 0


monsterSpawnFrequence = 0.2
monsterTimer = monsterSpawnFrequence

state = "alive"
bulletSpeed = 900
bg = nil

player = nil

function love.load()
    love.window.setFullscreen(false)
    love.mouse.setVisible(true)

    player = Player:new()

    bg = love.graphics.newImage("gfx/bg.jpg")
    ships = love.graphics.newImage("gfx/ships.gif")
    qEnemy = love.graphics.newQuad(130, 130, 55, 55, ships:getWidth(), ships:getHeight())
    crossHair = love.graphics.newImage("gfx/crosshair.png")
    
    -- Cursor
    cursor = love.mouse.newCursor("gfx/crosshair.png", 0, 0)
    love.mouse.setCursor(cursor)

    -- BG music
    -- bgMusic = love.audio.newSource("sfx/Azureflux_-_05_-_Expedition.mp3")
    -- bgMusic:play()
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
    love.graphics.print("Score: " .. score, 25, 25)    
    love.graphics.print("Deaths: " .. deaths, 25, 35)
    
    -- Draw player
    player:draw()

    -- 
    for i,bullet in ipairs(bullets) do
        bullet:draw()
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

    -- Update player
    player:update(dt)

    -- Update bullets
    for i, bullet in ipairs(bullets) do
        bullet:update(dt)
    end

    -- Bullet collision TODO
    -- for x, bullet in ipairs(bullets) do
    --     for i, monster in ipairs(monsters) do
    --         if bullet.x < monster.x + monster.width and 
    --            bullet.x + bullet.width > monster.x and
    --            bullet.y < monster.y + monster.height and
    --            bullet.y + bullet.height > monster.y then
               
    --            monster.state = "dead"
    --            table.remove(bullets, x)
    --            score = score + 1
    --        end
    --    end
    -- end

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
    -- for i, monster in ipairs(monsters) do
    --     if monster.state == "alive" then
    --         if monster.x < player.x + player.radius and 
    --            monster.x + 55 > player.x and
    --            monster.y < player.y + player.radius and
    --            monster.y + 55 > player.y then
    --            state = "player_dead"
    --            deaths = deaths + 1
    --        end
    --    end
    -- end
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
    table.insert(bullets, player:shoot(love.mouse.getX(), love.mouse.getY()))
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
