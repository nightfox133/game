function love.load()
    player = {} -- init 
    -- atrr
    player.x = 400
    player.y = 400
    player.speed = 10

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
    love.graphics.circle("fill", player.x, player.y, 10)
end