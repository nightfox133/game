-- menu.lua
local menu = {}


    
local red = {1, 0, 0}
local green = {0, 1, 0}
local blue = {0, 0, 1}

local color = {.5, .5, .5}



local currentState = "menu"  -- We start in the menu state
local buttons = {}
local selectedButton = 1

local img1 = love.graphics.newImage('maps/GUI_temp/UI/TopPatternBG_116x67.png')
local img2 = love.graphics.newImage('maps/GUI_temp/UI/PatternMiddleBottomBG_199x48.png')

-- Menu Font
local menuFont = love.graphics.newFont(30)
local buttonWidth, buttonHeight = 200, 50

-- Define the buttons
buttons = {
    {text = "Start Game", action = function() currentState = "game" end},
    {text = "Quit", action = function() love.event.quit() end}
}

-- Initialize menu (optional)
function menu.load()
    -- Initialize any resources or settings related to the menu here.
end

-- Update menu (optional)
function menu.update(dt)
    -- Update menu logic (if needed)
end

-- Draw the start menu
function menu.draw()
    if currentState == "menu" then
        love.graphics.setFont(menuFont)
        love.graphics.print("Start Menu", love.graphics.getWidth() / 2 - 100, 50)

        -- Draw buttons
        for i, button in ipairs(buttons) do
            local yPos = 100 + (i - 1) * (buttonHeight + 10)
            if i == selectedButton then
                love.graphics.setColor(0.5, 0.5, 1)  -- Highlight selected button
            else
                love.graphics.setColor(1, 1, 1)  -- Normal button color
            end
            love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - buttonWidth / 2, yPos, buttonWidth, buttonHeight)
            love.graphics.setColor(color)  -- Text color
            love.graphics.print(button.text, love.graphics.getWidth() / 2 - buttonWidth / 2 + 20, yPos + 15)

            love.graphics.draw(img1, 0, 0, 0, 3.6, 3)
            love.graphics.draw(img2, 0, 455, 0, 4.1, 3)
        end

    elseif currentState == "game" then
        -- Main game logic goes here (replace with your game code)
        love.graphics.setFont(menuFont)
        love.graphics.print("Game is running! Press Escape to return to the menu.", 50, 50)
    end
end

-- Handle keyboard input for the menu
function menu.keypressed(key)
    if currentState == "menu" then
        if key == "down" then
            selectedButton = math.min(selectedButton + 1, #buttons)
        elseif key == "up" then
            selectedButton = math.max(selectedButton - 1, 1)
        elseif key == "return" then
            -- Execute the action of the selected button
            buttons[selectedButton].action()
        end
    elseif currentState == "game" and key == "escape" then
        -- Return to the menu from the game state
        currentState = "menu"
    end
end

-- Return the current state so it can be checked externally (main.lua)
function menu.getState()
    return currentState
end

return menu
