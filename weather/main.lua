local disasters = {
    {name = "Earthquake", risk = "High", description = "High risk of earthquakes in this region.", image = "images/earthquake.jpg"},
    {name = "Flood", risk = "Medium", description = "Medium risk of floods during the rainy season.", image = "images/flood.jpg"},
    {name = "Tsunami", risk = "Low", description = "Low risk of tsunamis.", image = "images/tsunami.jpg"},
    {name = "Hurricane", risk = "High", description = "High risk of hurricanes during the storm season.", image = "images/hurricane.jpg"},
}

local pastData = {
    Earthquake = {5, 4, 6, 7, 5, 6, 7, 8, 5, 6},
    Flood = {3, 5, 2, 4, 3, 4, 5, 2, 3, 4},
    Tsunami = {1, 2, 1, 0, 1, 2, 1, 1, 0, 1},
    Hurricane = {6, 7, 5, 6, 7, 8, 6, 7, 5, 6},
}

local selectedDisaster = nil
local images = {}

function love.load()
    love.window.setTitle("Disaster Risk Management")
    love.graphics.setBackgroundColor(1, 1, 1) -- White background
    font = love.graphics.newFont(14)
    love.graphics.setFont(font)

    -- Load images with error handling
    for _, disaster in ipairs(disasters) do
        local success, img = pcall(love.graphics.newImage, disaster.image)
        if success then
            images[disaster.name] = img
            print("Successfully loaded image for " .. disaster.name)
        else
            print("Error loading image for " .. disaster.name .. ": " .. img)
            images[disaster.name] = nil
        end
    end
end

function love.draw()
    love.graphics.setColor(0, 0, 0) -- Black color

    love.graphics.print("Disaster Risk Management App", 20, 20)
    love.graphics.print("Select a disaster to view details:", 20, 50)

    for i, disaster in ipairs(disasters) do
        local y = 80 + (i - 1) * 30
        love.graphics.print(disaster.name, 20, y)
    end

    if selectedDisaster then
        love.graphics.setColor(0.2, 0.2, 0.8)
        love.graphics.print("Details for " .. selectedDisaster.name, 300, 80)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("Risk Level: " .. selectedDisaster.risk, 300, 110)
        love.graphics.print("Description: " .. selectedDisaster.description, 300, 140)

        -- Draw image if available
        local img = images[selectedDisaster.name]
        if img then
            love.graphics.draw(img, 300, 170, 0, 0.5, 0.5) -- Scale image to 50%
        else
            love.graphics.print("Image not available", 300, 170)
        end

        -- Draw risk level graph
        drawRiskLevelGraph(300, 300, selectedDisaster.risk)

        -- Draw past 10 years data graph
        drawPastDataGraph(550, 300, pastData[selectedDisaster.name])
    end
end

function drawRiskLevelGraph(x, y, risk)
    local riskLevels = {Low = 50, Medium = 125, High = 200}
    local riskWidth = riskLevels[risk] or 0

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", x, y, 200, 30)
    love.graphics.setColor(0.2, 0.2, 0.8)
    love.graphics.rectangle("fill", x, y, riskWidth, 30)
end

function drawPastDataGraph(x, y, data)
    if not data then return end

    local barWidth = 15
    local spacing = 5
    local maxHeight = 100

    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Past 10 Years Data", x, y - 20)

    for i, value in ipairs(data) do
        local barHeight = (value / 10) * maxHeight
        local barX = x + (i - 1) * (barWidth + spacing)
        local barY = y + maxHeight - barHeight

        love.graphics.setColor(0.2, 0.2, 0.8)
        love.graphics.rectangle("fill", barX, barY, barWidth, barHeight)

        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", barX, barY, barWidth, barHeight)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        for i, disaster in ipairs(disasters) do
            local disasterY = 80 + (i - 1) * 30
            if y >= disasterY and y <= disasterY + 20 then
                selectedDisaster = disaster
                break
            end
        end
    end
end
