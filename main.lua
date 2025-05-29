function love.load()
  love.window.setMode(800, 600, {resizable=true})
  math.randomseed(os.time() + tonumber(tostring(os.clock()):reverse():sub(1,6)))
  ball = love.graphics.newImage("asset/ball.png")
  hit = love.audio.newSource("asset/bounce.mp3","static")
  metalic = love.audio.newSource("asset/metal.wav","static")
  retry = love.graphics.newImage("asset/retry.png")
  scale = 0.1
  ballWidth = ball:getWidth() * scale
  ballHeight = ball:getHeight() * scale
  ballx = 200
  bally = 200
  barx = 200
  bary = 400
  barWidth = 100
  barHeight = 20
  ballvelocx = math.random(2) == 1 and -200 or 200
  ballvelocy = 200
  score = 0
  scoreFont = love.graphics.newFont(25)
  gameOver = false
  love.window.setTitle("Ball Game")
  showStartMessage = true
  retryScale = 0.3
  retryX = love.graphics.getWidth() / 2 - (retry:getWidth() * retryScale) / 2
  retryY = love.graphics.getHeight() / 2 + 20
  retryWidth = retry:getWidth() * retryScale
  retryHeight = retry:getHeight() * retryScale

end

function love.draw()
  love.graphics.clear(102/255, 204/255, 255/255, 1)
  if showStartMessage then
    love.graphics.printf("PRESS ARROW KEYS TO PLAY", 0, love.graphics.getHeight() / 2 - 20, love.graphics.getWidth(), "center")
  end
  
  love.graphics.setFont(scoreFont)
  love.graphics.print("Score: " .. score, 10, 10)
  love.graphics.draw(ball, ballx, bally, 0, scale, scale)
  love.graphics.rectangle("fill", barx, bary, barWidth, barHeight, 4, 4)
  if gameOver then
    love.graphics.printf("GAME OVER", 0, love.graphics.getHeight() / 2 - 20, love.graphics.getWidth(), "center")
    love.graphics.draw(retry, love.graphics.getWidth() / 2 - (retry:getWidth() * 0.3) / 2, love.graphics.getHeight() / 2 + 20, 0, 0.3, 0.3)
  end
end

function love.update(dt)
  if gameOver then 
    return 
  end
  if not showStartMessage then
  bally = bally + ballvelocy * dt
  ballx = ballx + ballvelocx * dt
  if love.keyboard.isDown("right") then
    barx = math.min(barx + 300 * dt, love.graphics.getWidth() - barWidth)
  elseif love.keyboard.isDown("left") then
    barx = math.max(barx - 300 * dt, 0)
  end
  if ballx < 0 then
    ballx = 0
    ballvelocx = -ballvelocx
    metalic:play()
  elseif ballx + ballWidth > love.graphics.getWidth() then
    ballx = love.graphics.getWidth() - ballWidth
    ballvelocx = -ballvelocx
    metalic:play()
  end
  if bally < 0 then
    bally = 0
    ballvelocy = -ballvelocy
    metalic:play()
  end
  if bally + ballHeight > love.graphics.getHeight() then
    gameOver = true
  end
  Collision()
  retryScale = 0.3
  retryX = love.graphics.getWidth() / 2 - (retry:getWidth() * retryScale) / 2
  retryY = love.graphics.getHeight() / 2 + 20
  retryWidth = retry:getWidth() * retryScale
  retryHeight = retry:getHeight() * retryScale
  end
end

function Collision()
  if bally + ballHeight >= bary and
     bally <= bary + barHeight and
     ballx + ballWidth >= barx and
     ballx <= barx + barWidth then
    ballvelocy = -ballvelocy
    bally = bary - ballHeight
    score = score + 1
    hit:play()
  end
end
function love.keypressed(key)
  if showStartMessage then
    showStartMessage = false
  end
end
function love.mousepressed(x, y, button)
  if gameOver and button == 1 then
    if x >= retryX and x <= retryX + retryWidth and
       y >= retryY and y <= retryY + retryHeight then
      -- Reset the game
      math.randomseed(os.time() + tonumber(tostring(os.clock()):reverse():sub(1,6)))
      ballx = 200
      bally = 200
      ballvelocx = math.random(2) == 1 and -200 or 200
      ballvelocy = 200
      barx = 200
      score = 0
      gameOver = false
      showStartMessage = true
    end
  end
end
