-- player.lua

local anim8 = require 'libraries/anim8'

local Player = {}
Player.x = 1000
Player.y = 450
Player.walkSpeed = 200
Player.sprintSpeed = Player.walkSpeed * 1.8
Player.speed = Player.walkSpeed
Player.spriteSheet = love.graphics.newImage('sprites/simplePlayerSheet.png')
Player.grid = anim8.newGrid(64, 63, Player.spriteSheet:getWidth(), Player.spriteSheet:getHeight(), 0, 10)

Player.animations = {
    up = anim8.newAnimation(Player.grid("1-4", 4), 0.2),
    down = anim8.newAnimation(Player.grid("1-4", 1), 0.2),
    left = anim8.newAnimation(Player.grid("1-4", 2), 0.2),
    right = anim8.newAnimation(Player.grid("1-4", 3), 0.2),
}

Player.anim = Player.animations.left

function Player.load(world)
    -- Collider initialization
    Player.collider = world:newBSGRectangleCollider(Player.x, Player.y, 38, 53, 12)
    Player.collider:setFixedRotation(true)
end

function Player.update(dt)
    local isMoving = false
    local vx, vy = 0, 0

    -- Update position based on input
    if love.keyboard.isDown("right") then
        vx = Player.speed
        Player.anim = Player.animations.right
        isMoving = true
    end
    if love.keyboard.isDown("left") then
        vx = -Player.speed
        Player.anim = Player.animations.left
        isMoving = true
    end
    if love.keyboard.isDown("up") then
        vy = -Player.speed
        Player.anim = Player.animations.up
        isMoving = true
    end
    if love.keyboard.isDown("down") then
        vy = Player.speed
        Player.anim = Player.animations.down
        isMoving = true
    end

    if vx ~= 0 and vy ~= 0 then
        local length = math.sqrt(vx^2 + vy^2)
        vx = vx / length * Player.speed
        vy = vy / length * Player.speed
    end

    -- Sprinting
    if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
        Player.speed = Player.sprintSpeed
    else
        Player.speed = Player.walkSpeed
    end

    Player.collider:setLinearVelocity(vx, vy)

    if not isMoving then
        Player.anim:gotoFrame(1) -- Go to the idle frame
    end

    Player.anim:update(dt)
    Player.x = Player.collider:getX() - 32
    Player.y = Player.collider:getY() - 30
end

function Player.draw()
    Player.anim:draw(Player.spriteSheet, Player.x, Player.y)
end

return Player