local player = {}
local bullets = {}
local enemies = {}
local score = 0
local playerSpeed = 300
local bulletSpeed = 500
local enemySpeed = 100
local spawnTimer = 0
local spawnInterval = 2
local fireRate = 0.2
local fireTimer = 0
function love.load()
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() - 50
    player.width = 50
    player.height = 20
end
function love.update(dt)
    if love.keyboard.isDown("left") then
        player.x = player.x - playerSpeed * dt
    elseif love.keyboard.isDown("right") then
        player.x = player.x + playerSpeed * dt
    end
    player.x = math.max(0, math.min(player.x, love.graphics.getWidth() - player.width))
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet.y = bullet.y - bulletSpeed * dt
        if bullet.y < 0 then
            table.remove(bullets, i)
        end
    end
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        enemy.y = enemy.y + enemySpeed * dt
        if enemy.y > love.graphics.getHeight() then
            table.remove(enemies, i)
        end
    end
    spawnTimer = spawnTimer + dt
    if spawnTimer >= spawnInterval then
        spawnTimer = 0
        local enemy = {}
        enemy.x = math.random(0, love.graphics.getWidth() - 50)
        enemy.y = -50
        enemy.width = 50
        enemy.height = 20
        table.insert(enemies, enemy)
    end
    fireTimer = fireTimer + dt
    if fireTimer >= fireRate then
        fireTimer = 0
        shootBullet()
    end
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        for j = #enemies, 1, -1 do
            local enemy = enemies[j]
            if bullet.x < enemy.x + enemy.width and
               bullet.x + bullet.width > enemy.x and
               bullet.y < enemy.y + enemy.height and
               bullet.y + bullet.height > enemy.y then
                table.remove(bullets, i)
                table.remove(enemies, j)
                score = score + 1
                break
            end
        end
    end
end

function love.draw()
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    for _, bullet in ipairs(bullets) do
        love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.width, bullet.height)
    end
    for _, enemy in ipairs(enemies) do
        love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.width, enemy.height)
    end
  
    love.graphics.print("Score: " .. score, 10, 10)
end
function shootBullet()
    local bullet = {}
    bullet.x = player.x + player.width / 2 - 2.5
    bullet.y = player.y
    bullet.width = 5
    bullet.height = 10
    table.insert(bullets, bullet)
end
