Ball = require 'objects/Ball'

local Table = Object:extend()

local start = {x = 0, y = 0}
local final = {x = 0, y = 0}
local playing = false
local hit = false
local force = 40

function Table:new()
  world = love.physics.newWorld()
  ball = Ball(world, 100, 100, 10)
  ball2 = Ball(world, 200, 300, 10)

  -- bounds = {}
  -- bound.body = love.physics.newBody(world, love., 40) 
  -- bound.shape = love.physics.newEdgeShape(0, 0, 560, 40)
  -- bound.fixture = love.physics.newFixture(bound.body, bound.shape)
end

function Table:update(dt)
  world:update(dt)
  ball:update(dt)
  ball2:update(dt)

  ball.body:applyForce(gforce(ball.body, ball2.body))
  ball2.body:applyForce(gforce(ball2.body, ball.body))

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
  ball2:draw()
  if playing then love.graphics.line(start.x, start.y, final.x, final.y) end
end

function hit(body)
  body:applyForce((start.x - final.x) * force, (start.y - final.y) * force) 
end

function gforce(b1, b2)
  local G = 500000
  local r = {}
  r.x = b1:getX() - b2:getX()
  r.y = b1:getY() - b2:getY()
  local mag = math.sqrt(r.x * r.x + r.y * r.y)
  local r_hat = {}
  r_hat.x, r_hat.y = r.x/mag, r.y/mag
  local force_mag = (G*b1:getMass()*b2:getMass()) / (mag*mag)
  debug[1] = force_mag
  return -force_mag*r_hat.x, -force_mag*r_hat.y
end


return Table
