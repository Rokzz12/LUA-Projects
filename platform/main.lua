-- love.load
function love.load(arg)
  love.window.setMode(900, 700)
  love.graphics.setBackgroundColor(155, 214, 255)

  myWorld = love.physics.newWorld(0, 500, false)
  myWorld:setCallbacks(beginContact, endContact, preSolve, postSolve)

  sprites = {}
  sprites.coin_sheet = love.graphics.newImage("sprites/coin_sheet.png")
  sprites.player_jump = love.graphics.newImage("sprites/player_jump.png")
  sprites.player_stand = love.graphics.newImage("sprites/player_stand.png")

  require("player")
  require("coin")
  require("show")
  anim8 = require("anim8-master/anim8")
  sti = require("Simple-Tiled-Implementation-master/sti")
  cameraFile = require("hump-master/camera")

  cam = cameraFile()
  gameState = 1
  timer = 0
  myFont = love.graphics.newFont(30)

  saveData = {}
  saveData.bestTime = 999

  --love.filesystem.remove("data.lua")
  if love.filesystem.exists("data.lua") then
    local data = love.filesystem.load("data.lua")
    data()
  end

  platforms = {}
  coins = {}

  gameMap = sti("maps/gameMap.lua")

  for i, obj in pairs(gameMap.layers["Platforms"].objects) do
    spawnplatform(obj.x, obj.y, obj.width, obj.height)
  end

  for i, obj in pairs(gameMap.layers["Coins"].objects) do
    spawnCoin(obj.x, obj.y)
  end
end

-- love.update
function love.update(dt)
  myWorld:update(dt)
  playerUpdate(dt)
  gameMap:update(dt)
  coinUpdate(dt)

  cam:lookAt(player.body:getX(), love.graphics.getHeight()/2)

  for i, c in ipairs(coins) do
    c.animation:update(dt)
  end

  if gameState == 2 then
    timer = timer + dt
  end

  if #coins == 0 and gameState == 2 or player.died then
    gameState = 1
    player.body:setPosition(198, 443)

    for i, obj in pairs(gameMap.layers["Coins"].objects) do
      spawnCoin(obj.x, obj.y)
    end

    if timer < saveData.bestTime and not player.died then
      saveData.bestTime = math.floor(timer)
      love.filesystem.write("data.lua", table.concat({ "saveData = { bestTime = " .. saveData.bestTime .. " }" }, "\n"))
    end
  end
end

-- love.draw
function love.draw()
  cam:attach()

  gameMap:drawLayer(gameMap.layers["Tile Layer 1"])

  love.graphics.draw(player.sprite, player.body:getX(), player.body:getY(), nil, player.direction, 1, sprites.player_stand:getWidth()/2, sprites.player_stand:getHeight()/2)

  for i, c in ipairs(coins) do
    c.animation:draw(sprites.coin_sheet, c.x, c.y, nil, nil, nil, 20.5, 21)
  end

  cam:detach()

  if gameState == 1 then
    love.graphics.setFont(myFont)
    love.graphics.printf("Press any key to begin!", 0, 50, love.graphics.getWidth(), "center")
    love.graphics.printf("Best Time: " .. saveData.bestTime, 0, 150, love.graphics.getWidth(), "center")
  end

  love.graphics.print("Time: " .. math.floor(timer), 10, 660)
end

-- love.keypressed
function love.keypressed(key, scancode, isrepeat)
  if key == "up" and player.grounded == true then
    player.body:applyLinearImpulse(0, -2800)
  end

  if gameState == 1 then
    player.died = false
    gameState = 2
    timer = 0
  end
end

-- spawnplatform
function spawnplatform(x, y, width, height)
  local platform = {}
  platform.body = love.physics.newBody(myWorld, x, y, "static")
  platform.shape = love.physics.newRectangleShape(width/2, height/2, width, height)
  platform.fixture = love.physics.newFixture(platform.body, platform.shape)
  platform.width = width
  platform.height = height

  table.insert(platforms, platform)
end

-- beginContact
function beginContact(a, b, coll)
  player.grounded = true
end

-- endContact
function endContact(a, b, coll)
  player.grounded = false
end

-- distanceBetween
function distanceBetween(x1, y1, x2, y2)
  return math.sqrt
end