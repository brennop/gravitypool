Ball = require 'objects/Ball'
Blackhole = require 'objects/Blackhole'

local Table = Object:extend()

local start = vector(0, 0)
local final = vector(0, 0)
local playing = false
local hit = false
local pathSize = 8
local pathStep = 0.4
local force = 150
local n = 4
local score = {red = 0, yellow = 0}

function Table:new()
  world = love.physics.newWorld()
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  ball = Ball(world, love.graphics:getWidth() * 0.25,
  love.graphics:getHeight()/2, 10, 0.6, 'white')
  -- category 1
  -- mask set to 1 (walls) and 2 (balls)
  ball.fixture:setFilterData(1, 3, 0)

  bodies = {}
  bodies[1] = ball
  local col = 1 -- current column
  local nBalls = (n*n+n)/2
  local colors = M.shuffle(M.append(M.vector('red', nBalls/2), M.vector('yellow', nBalls/2)))
  for i = 1, nBalls, 1 do
    local s = (col * (col+1))/2 -- triangular number (sum of n first number)
    bodies[i+1] = Ball(world, love.graphics:getWidth() * 0.65 + col * 18,
    love.graphics:getHeight()/2 + (i-s)*20 + (col-1)*10, 10, 1, colors[i])
    if s == i then col = col + 1 end -- increase column at column end
  end

  local offset = 60
  -- creates table boundaries
  bounds = {}
  local boundPos = vector(0, 0)
  local boundDir = vector(0, 1)
  for i,_ in ipairs(M.range(4)) do
    bounds[i] = {}
    bounds[i].body = love.physics.newBody(world, 0, 0)
    local newPos = boundPos + boundDir:permul(vector(love.graphics.getWidth(), love.graphics.getHeight()))
    bounds[i].shape = love.physics.newEdgeShape(boundPos.x, boundPos.y, newPos.x, newPos.y)
    bounds[i].fixture = love.physics.newFixture(bounds[i].body, bounds[i].shape)
    bounds[i].fixture:setUserData('bound')
    -- creates blackholes
    table.insert(bodies, Blackhole(world, boundPos.x + offset * boundDir.x + offset * boundDir.y, boundPos.y - offset * boundDir.x + offset * boundDir.y, 0.01, 3))
    boundPos = newPos
    boundDir:rotateInplace(-math.pi/2)
  end

  -- create path on clicking
  path = {}
  for i = 1, pathSize, 1 do
    path[i] = {x = 0, y = 0, r = 3}  
  end
end

function Table:update(dt)
  world:update(dt)
  ball:update(dt)
  for _, b in ipairs(bodies) do b:update(dt) end

  -- calculate gravity force for each ball
  for i, b in ipairs(bodies) do
    local acc = {0, 0}
    for j, otherBall in ipairs(bodies) do
      if i ~= j then
        local force = gforce(b, otherBall)
        acc[1] = acc[1] + force[1] 
        acc[2] = acc[2] + force[2] 
      end
    end
    b.body:applyForce(acc[1], acc[2])
  end

  local mousePos = vector(love.mouse.getPosition())
  local ballPos = vector(ball.body:getPosition())
  local ballRad = ball.shape:getRadius()
  
  -- checks if player has clicked
  if love.mouse.isDown(1) then
    -- if click has already happen, set final position
    if playing then
      final = mousePos
      start = ballPos
      for i, path in ipairs(path) do
        path.x, path.y = ((ballPos - mousePos)*i*pathStep + ballPos):unpack()
        if path.x < 0 then path.x = path.x * -1 end 
        if path.y < 0 then path.y = path.y * -1 end 
        if path.x > love.graphics:getWidth() then path.x = 2 * love.graphics:getWidth() - path.x end
        if path.y > love.graphics:getHeight() then path.y = 2 * love.graphics:getHeight() - path.y end
      end
    -- else, checks if mouse is on the ball
    elseif
    mousePos.x < (ballPos.x + ballRad) and
    mousePos.x > ballPos.x - ballRad and
    mousePos.y < ballPos.y + ballRad and
    mousePos.y > ballPos.y - ballRad then
      -- sets position on first frame
      start = ballPos
      final = mousePos
      playing = true
    end
  end

  -- end of click
  if not love.mouse.isDown(1) and playing then
    hit(ball.body)
    playing = false
  end

  -- checks if ball has fallen
  -- should use separate tables for balls / blackholes to simplify code
  -- for _, ball in ipairs(M.initial(M.rest(bodies, 2), 4)) do
  --   for _, bh in ipairs(M.last(bodies, 4)) do 
  --     if ball.body and math.abs(ball.body:getX() - bh.body:getX()) < 0.2 and math.abs(ball.body:getY() - ball.body:getY()) < 0.2 then
  --       score[ball.fixture:getUserData()] = score[ball.fixture:getUserData()] + 1  
  --       bodies = M.reject(bodies, function(b) return ball.body == b.body end)
  --       -- ball.body:destroy()
  --     end
  --   end
  -- end
end

function Table:draw()
  if playing then 
    for i, path in ipairs(path) do
      love.graphics.setColor(1, 1, 1, 0.85 - i*0.02)
      love.graphics.circle("fill", path.x, path.y, path.r)
      love.graphics.setColor(1, 1, 1, 1)
    end
  end
  for _, body in ipairs(bodies) do body:draw() end
  for _, bound in ipairs(bounds) do 
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.line(bound.body:getWorldPoints(bound.shape:getPoints()))
  end
  if playing then love.graphics.line(start.x, start.y, final.x, final.y) end
  debug[1] = 'red: '..score['red']
  debug[2] = 'yellow: '..score['yellow']
end

function beginContact(a, b, coll)
  if(M.include({'red','yellow'}, a:getUserData()) and b:getUserData() == 'blackhole') then
    score[a:getUserData()] = score[a:getUserData()] + 1  
    bodies = M.reject(bodies, function(b) return a:getBody() == b.body end)
    a:getBody():destroy()
  end
end

function hit(body)
  body:applyForce((start.x - final.x) * force, (start.y - final.y) * force) 
end

function gforce(b1, b2)
  local G = 5000
  local r = {}
  r.x = b1.body:getX() - b2.body:getX()
  r.y = b1.body:getY() - b2.body:getY()
  local mag = math.sqrt(r.x * r.x + r.y * r.y)
  local r_hat = {}
  r_hat.x, r_hat.y = r.x/mag, r.y/mag
  local force_mag = (G*b1.mass*b2.mass) / (mag*mag)
  return {-force_mag*r_hat.x, -force_mag*r_hat.y}
end


return Table
