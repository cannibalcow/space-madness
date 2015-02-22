class = require 'lib.middleclass'
Tools = require("lib.tools")
Bullet = require("lib.bullet")
local Player = require("lib.player")
local Monster = require("lib.monster")

bullets = {}
monsters = {}

width = 1920
height = 1280

gameScore = 0
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
        love.graphics.print("YOU DEAD! YOU NO GOOD! YOU SCORE: " .. gameScore , love.window.getWidth() / 2 - 100, love.window.getHeight() / 2)
        love.graphics.print("CLICK MOUSE TO PLAY AGAIN!" , love.window.getWidth() / 2 - 100, love.window.getHeight() / 2 + 25)
        return 
    end

    love.graphics.draw(bg, 0, 0)

    -- Draw info
    love.graphics.print("Score: " .. gameScore, 25, 25)    
    love.graphics.print("Deaths: " .. deaths, 25, 35)
    
    -- Draw player
    player:draw()

    -- Draw bullets
    for i,bullet in ipairs(bullets) do
        bullet:draw()
    end

    -- Draw monster
    for i, monster in ipairs(monsters) do
        monster:draw()
    end            

    -- Reset color
    love.graphics.setColor(255,255,255)
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
    if table.maxn(bullets) > 0 then
        for i, bullet in ipairs(bullets) do
            bullet:update(dt)
        end
    end

    -- Bullet collision
    if table.maxn(bullets) > 0 then
        for i, bullet in ipairs(bullets) do
            for x, monster in ipairs(monsters) do
                if bullet:isMonsterCollition(monster) then
                    score(1)
                    monster:setDead()

                    table.remove(bullets, i)
                end
            end
        end
    end

    -- spawn monster
    if monsterReady(dt) then
        spawnMonster()
    end

    -- move monster
    for i, monster in ipairs(monsters) do
        monster:update(dt)

        if monster:isOutOfBounds() then
            table.remove(monsters, i)
        end
    end

    -- player monster collision detection
    if table.maxn(monsters) > 0 then
        for i, monster in ipairs(monsters) do
            if monster:isPlayerCollision(player) then
                state = "player_dead"
            end
        end
    end
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
       resetGame()
    end

    -- shoot
    pos = table.maxn(bullets)
    local bullet = player:shoot(love.mouse.getX(), love.mouse.getY())

    if bullet ~= nil then
        table.insert(bullets, pos+1, bullet)
    end
end

function monsterReady(dt) 
    monsterTimer = monsterTimer - ( 1 * dt) 
    if monsterTimer < 0 then
        monsterTimer = monsterSpawnFrequence
        return true
    end
end

function spawnMonster() 
    table.insert(monsters, Monster:new())
end

function resetGame()
    state = "play"
    gameScore = 0

    for i in pairs(monsters) do
        monsters[i] = nil
    end

    for i,bullet in ipairs(bullets) do
        bullets[i] = nil
    end
end

function score(points)
    gameScore = gameScore + points
end