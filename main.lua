function love.load()
    -- import

    --init toggle vars--
    toggle = require "toggle" 
      gameMusic = toggle:new()
      test = toggle:new()


    wf = require "libraries/windfield"
    world = wf.newWorld(0, 0)


    camera = require 'libraries/camera'
    cam = camera()
    
    anim8 = require 'libraries/anim8'
    
    sti = require 'libraries/sti'
    gameMap = sti('maps/36x36.lua')
    
    --un blurry
    love.graphics.setDefaultFilter("nearest", "nearest")




    gs = .2 -- frame length ().2)

    player = {} -- init 
    -------atrr-------
        player.x = 1000
        player.y = 450
        
        --speed--
        player.walkSpeed = 200 --default (200)
        player.sprintSpeed = player.walkSpeed * 1.8 -- (1.8)
        player.speed = player.walkSpeed -- set

    --sprites--
    player.spriteSheet = love.graphics.newImage('sprites/simplePlayerSheet.png')

    background = love.graphics.newImage('weirdTown.png')

    -- red hood is (19, 21)
    player.grid = anim8.newGrid(64, 63, player.spriteSheet:getWidth(), player.spriteSheet:getHeight(), 0 , 10) --geuss and check

    player.animations = {} 
    -- default animations                              --number row time
    player.animations.up = anim8.newAnimation(player.grid("1-4", 4), gs) -- (.2 || .1)
    player.animations.down = anim8.newAnimation(player.grid("1-4", 1), gs)
    player.animations.left = anim8.newAnimation(player.grid("1-4", 2), gs)
    player.animations.right = anim8.newAnimation(player.grid("1-4", 3), gs) -- idle 6
    ---------------------------------------------------------------------

    player.anim = player.animations.left

    player.collider = world:newBSGRectangleCollider(player.x, player.y, 38, 53, 12) --(38,53,12)
    player.collider:setFixedRotation(true)

    walls = {}
    if gameMap.layers["walls"] then 
        for i, obj in pairs(gameMap.layers["walls"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end

    --sounds--
        -- sound fx: static
        -- muisic: stream
    sounds = {}
    sounds.blip = love.audio.newSource("sounds/blip.mp3", "static")
    sounds.music = love.audio.newSource("sounds/8bit-music-test.mp3", "stream")

    sounds.music:play()
    sounds.music:setLooping(true)
end

function love.update(dt)
    local isMoving = false
    
    -- CONTROLS --

    local vx = 0
    local vy = 0

    -- right arrow key
    if love.keyboard.isDown("right") then
        vx = player.speed
        player.anim = player.animations.right
        isMoving = true 
    end

    -- left arrow key
    if love.keyboard.isDown("left") then
        vx =  player.speed * -1
        player.anim = player.animations.left
        isMoving = true
    end

    -- up arrow key
    if love.keyboard.isDown("up") then
        vy =  player.speed * -1
        player.anim = player.animations.up
        isMoving = true
    end

    -- down arrow key
    if love.keyboard.isDown("down") then
        vy =  player.speed
        player.anim = player.animations.down
        isMoving = true
    end

    -- shift key
    if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
        player.speed = player.sprintSpeed
    else
        player.speed = player.walkSpeed
    end

    -----update-------

    player.collider:setLinearVelocity(vx, vy)


    if isMoving == false then
        player.anim:gotoFrame(1) --goes to standing still frame
    end


    player.anim:update(dt) -- update
    
    world:update(dt)
    player.x = player.collider:getX() - 32
    player.y = player.collider:getY() - 30


    cam.x, cam.y = player.x, player.y
    local mapw = background:getWidth()
    local maph = background:getHeight()  

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    -- left bound
    if cam.x < w/2 then 
        cam.x = w/2
    end
    -- right bound
    if cam.x > mapw + w/2 then 
        cam.x = mapw + w/2
    end
    -- up bound
    if cam.y < h/2 then
        cam.y = h/2
    end
    -- bottom bound
    if cam.y > maph*2 + h then 
        cam.y = maph*2 + h
    end


    cam:lookAt(cam.x, cam.y) --follow player

end


function love.draw()
    local xBG, yBG = 3
    local xP, yP = 1, 1
    love.graphics.setColor(1, 1, 1) -- set default

    cam:attach()
        gameMap:drawLayer(gameMap.layers["walls"])
    
        love.graphics.draw(background, 0, 0, 0, xBG, yBG) --drawn first (back layer)

        
        --gameMap:drawLayer(gameMap.layers["ground"]) --(major distortion)


        player.anim:draw(player.spriteSheet, player.x, player.y, 0, xP, yP)
        world:draw()
    cam:detach()
    --text--
    love.graphics.setFont(love.graphics.newFont(20)) -- Sets the default font with size 14
    love.graphics.setColor(0, 0, 0) --text color
    love.graphics.print("Player: (" .. player.x .. ", " .. player.y .. ")", 0, 0) -- player location



    if test:get() then
        love.graphics.print("The toggle is ON", 400, 300)
    else
        love.graphics.print("The toggle is OFF", 400, 300)
    end
end

function love.keypressed(key)
    -- teloport
    if key == "space" then
        player.collider:setX(880)
        player.collider:setY(600)
    end
    -- attack
    if key == "a" then
        love.graphics.print("attack", 0, 0)
        sounds.blip:play()
    end
    
    if key == "m" then
        gameMusic:toggle()
        if gameMusic:get() then
            sounds.music:pause()
        else 
            sounds.music:play()
        end
    end
end