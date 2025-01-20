-- main.lua
local wf = require "libraries/windfield"
local camera = require 'libraries/camera'
local anim8 = require 'libraries/anim8'
local sti = require 'libraries/sti'
local toggle = require "toggle"
local calc = require 'calc'
local menu = require 'menu'  -- Require the menu.lua module
local Player = require 'player'  -- Require the Player module

function love.load()
    menu.load()
    
    -- Initialize toggle variables
    gameMusic = toggle:new()

    -- Setup world and camera
    world = wf.newWorld(0, 0)
    cam = camera()

    -- Load game map and background
    gameMap = sti('maps/36x36.lua')
    background = love.graphics.newImage('weirdTown.png')

    -- Set graphics filter
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Load player and initialize
    Player.load(world)

    -- Initialize walls from the map
    walls = {}
    if gameMap.layers["walls"] then 
        for i, obj in pairs(gameMap.layers["walls"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end

    -- Sound setup
    sounds = {}
    sounds.blip = love.audio.newSource("sounds/blip.mp3", "static")
    sounds.music = love.audio.newSource("sounds/8bit-music-test.mp3", "stream")
    sounds.music:play()
    sounds.music:setLooping(true)
end

function love.update(dt)
    if menu.getState() == "menu" then
        menu.update(dt)  -- Update the menu if in the "menu" state
    elseif menu.getState() == "game" then
        Player.update(dt)  -- Update player and game if in the "game" state
    end

    -- Camera follow player if in game state
    if menu.getState() == "game" then
        cam.x, cam.y = Player.x, Player.y

        local mapw = background:getWidth()
        local maph = background:getHeight()
        local w = love.graphics.getWidth()
        local h = love.graphics.getHeight()

        -- Camera boundaries
        if cam.x < w / 2 then
            cam.x = w / 2
        end
        if cam.x > mapw + w / 2 then
            cam.x = mapw + w / 2
        end
        if cam.y < h / 2 then
            cam.y = h / 2
        end
        if cam.y > maph * 2 + h then
            cam.y = maph * 2 + h
        end

        cam:lookAt(cam.x, cam.y)
        world:update(dt)  -- Update world (for collision detection)
    end
end

function love.draw()
    menu.draw()  -- Draw the menu or the game based on current state
    
    if menu.getState() == "game" then
        -- Game-specific drawing goes here
        local xBG, yBG = 3
        love.graphics.setColor(1, 1, 1)  -- Set default color
        cam:attach()
        
        -- Draw the game map and walls
        gameMap:drawLayer(gameMap.layers["walls"])

        -- Draw background
        love.graphics.draw(background, 0, 0, 0, xBG, yBG)

        -- Draw player animation
        Player.draw()

        -- Draw world colliders
        world:draw()
        cam:detach()

        -- Display player coordinates
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.setColor(0, 0, 0)  -- Text color
        love.graphics.print("Player: (" .. calc:round(Player.x) .. ", " .. calc:round(Player.y) .. ")", 0, 0)

        -- Toggle message
        if gameMusic:get() then
            love.graphics.print("music: OFF  'm' to toggle", 0, 20)
        else
            love.graphics.print("music: ON   'm' to toggle", 0, 20)
        end
    end
end

function love.keypressed(key)
    if menu.getState() == "menu" then
        menu.keypressed(key)  -- Handle key press in the menu
    elseif menu.getState() == "game" then
        -- Handle key presses during gameplay
        if key == "space" then
            Player.collider:setX(880)
            Player.collider:setY(600)
        end

        if key == "a" then
            love.graphics.print("attack", 0, 0)
            sounds.blip:play()
        end

        -- Toggle music on 'm' key press
        if key == "m" then
            gameMusic:toggle()
            if gameMusic:get() then
                sounds.music:pause()
            else
                sounds.music:play()
            end
        end

        if key == "escape" then
            love.event.quit()  -- Quit the game
        end
    end
end
