function love.load()
    player = {} -- init 
    -- atrr
    player.x = 100
    player.y = 100
    player.speed = 10

    -- sprites
    --background = {}
    player.sprite = love.graphics.newImage('sprites/ashPlayer.png')
    background = love.graphics.newImage('sprites/grassyBG.png')
    w, l = 100, 100
end

function love.update(dt)
    -- CONTROLS --

    -- right arrow key
    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed
    end

    -- left arrow key
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed
    end

    -- up arrow key
    if love.keyboard.isDown("up") then
        player.y = player.y - player.speed
    end

    -- down arrow key
    if love.keyboard.isDown("down") then
        player.y = player.y + player.speed
    end
end

function love.draw()
    local xBG, yBG = 3, 3
    local xP, yP = .1, .1
    love.graphics.draw(background, 0, 0, 0, xBG, yBG) --drawn first (back layer)
    love.graphics.draw(player.sprite, player.x, player.y, 0, xP, yP)
    
end