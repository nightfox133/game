function love.load()
    -- import
    anim8 = require 'libraries/anim8'
    
    sti = require 'libraries/sti'
    gameMap = sti('maps/test.lua')
    
    --un blurry
    love.graphics.setDefaultFilter("nearest", "nearest")




    gs = .1 -- frame length

    player = {} -- init 
    -------atrr-------
        player.x = 150
        player.y = 450

        --speed--
        player.walkSpeed = 5 --default (5)
        player.sprintSpeed = player.walkSpeed * 1.8 -- (1.8)
        player.speed = player.walkSpeed -- set

    --sprites--
    player.sprite = love.graphics.newImage('sprites/ashPlayer.png')
    player.spriteSheet = love.graphics.newImage('sprites/playerSheet.png')

    background = love.graphics.newImage('sprites/grassyBG.png')

    -- red hood is (19, 21)
    player.grid = anim8.newGrid(19, 21, player.spriteSheet:getWidth(), player.spriteSheet:getHeight()) --geuss and check

    player.animations = {}                             --number row time
    player.animations.up = anim8.newAnimation(player.grid("1-4", 1), gs) -- (.2 || .1)
    player.animations.down = anim8.newAnimation(player.grid("1-3", 2), gs)
    player.animations.left = anim8.newAnimation(player.grid("1-4", 4), gs)
    player.animations.right = anim8.newAnimation(player.grid("1-3", 6), gs) -- idle 6

    player.anim = player.animations.left








end

function love.update(dt)
    local isMoving = false
    
    
    -- CONTROLS --

    -- right arrow key
    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed
        player.anim = player.animations.right
        isMoving = true
    end

    -- left arrow key
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed
        player.anim = player.animations.left
        isMoving = true
    end

    -- up arrow key
    if love.keyboard.isDown("up") then
        player.y = player.y - player.speed
        player.anim = player.animations.up
        isMoving = true
    end

    -- down arrow key
    if love.keyboard.isDown("down") then
        player.y = player.y + player.speed
        player.anim = player.animations.down
        isMoving = true
    end

    -- shift key
    if love.keyboard.isDown("lshift") then
        player.speed = player.sprintSpeed
    else
        player.speed = player.walkSpeed
    end

    -----update-------

    if isMoving == false then
        player.anim:gotoFrame(2) --goes to standing still frame
    end


    player.anim:update(dt) -- update


end


function love.draw()
    local xBG, yBG = 3, 3
    local xP, yP = 8, 8
    love.graphics.setColor(1, 1, 1) -- set default

    --woodsBG (-70, )
    gameMap:draw(-70, -35, 13, 10)
    --love.graphics.draw(background, 0, 0, 0, xBG, yBG) --drawn first (back layer)

    --love.graphics.draw(player.sprite, player.x, player.y, 0, xP, yP)
    player.anim:draw(player.spriteSheet, player.x, player.y, 0, xP, yP)
    
    --text--
    love.graphics.setFont(love.graphics.newFont(20)) -- Sets the default font with size 14
    love.graphics.setColor(0, 0, 0) --text color
    love.graphics.print("Player: (" .. player.x .. ", " .. player.y .. ")", 0, 0) -- player location
end
