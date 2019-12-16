Ball = require 'objects/Ball'

local Table = Object:extend()

local start = {x = 0, y = 0}
local final = {x = 0, y = 0}
local playing = false
local hit = false
local force = 100
local n = 4

function Table:new()
  world = love.physics.newWorld()
  ball = Ball(world, love.graphics:getWidth() * 0.25, love.graphics:getHeight()/2, 10, 0.6)

  balls = {}
  local col = 1 -- current column
  for i = 1, (n*n+n)/2, 1 do
    local s = (col * (col+1))/2 -- triangular number (sum of n first number)
    balls[i] = Ball(world, love.graphics:getWidth() * 0.65 + col * 18, love.graphics:getHeight()/2 + (i-s)*20 + (col-1)*10, 10, 1)
    if s == i then col = col + 1 end -- increase column at column end
  end

  table.insert(balls, ball)
  -- bounds = {}
  -- bound.body = love.physics.newBody(world, love., 40) 
  -- bound.shape = love.physics.newEdgeShape(0, 0, 560, 40)
  -- bound.fixture = love.physics.newFixture(bound.body, bound.shape)
end

function Table:update(dt)
  world:update(dt)
  ball:update(dt)
  for _, b in ipairs(balls) do b:update(dt) end

  -- calculate gravity force for each ball
  for i, b in ipairs(balls) do
    local acc = {0, 0}
    for j, otherBall in ipairs(balls) do
      if i ~= j then
        local force = gforce(b.body, otherBall.body)
        acc[1] = acc[1] + force[1] 
        acc[2] = acc[2] + force[2] 
      end
    end
    b.body:applyForce(acc[1], acc[2])
  end

  local mousePos = {}
  mousePos.x, mousePos.y = love.mouse.getPosition()
  local ballPos = {}
  ballPos.x, ballPos.y = ball.body:getPosition()
  local ballRad = ball.shape:getRadius()
  
  -- checks if player has clicked
  if love.mouse.isDown(1) then
    -- if click has already happen, set final position
    if playing then
      final = mousePos
      start = ballPos
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
end

function Table:draw()
  ball:draw()
  for _, b in ipairs(balls) do b:draw() end
  if playing then love.graphics.line(start.x, start.y, final.x, final.y) end
end

function hit(body)
  body:applyForce((start.x - final.x) * force, (start.y - final.y) * force) 
end

function gforce(b1, b2)
  local G = 10000
  local r = {}
  r.x = b1:getX() - b2:getX()
  r.y = b1:getY() - b2:getY()
  local mag = math.sqrt(r.x * r.x + r.y * r.y)
  local r_hat = {}
  r_hat.x, r_hat.y = r.x/mag, r.y/mag
  local force_mag = (G*b1:getMass()*b2:getMass()) / (mag*mag)
  return {-force_mag*r_hat.x, -force_mag*r_hat.y}
end


return Table
