Ball = require 'objects/Ball'

local Table = Object:extend()

local start = {x = 0, y = 0}
local final = {x = 0, y = 0}
local playing = false
local hit = false
local force = 10

function Table:new()
  world = love.physics.newWorld()
  ball = Ball(world, 100, 100, 10)
end

function Table:update(dt)
  world:update(dt)
  ball:update(dt)

  local mousePos = {}
  mousePos.x, mousePos.y = love.mouse.getPosition()
  local ballPos = {}
  ballPos.x, ballPos.y = ball.body:getPosition()
  local ballRad = ball.shape:getRadius()
  
  if love.mouse.isDown(1) then
    if playing then
      final = mousePos
    elseif
    mousePos.x < (ballPos.x + ballRad) and
    mousePos.x > ballPos.x - ballRad and
    mousePos.y < ballPos.y + ballRad and
    mousePos.y > ballPos.y - ballRad then
      start = mousePos
      playing = true
    end
  end

  if not love.mouse.isDown(1) and playing then
    hit(ball.body)
    playing = false
  end
end

function Table:draw()
  ball:draw()
  if playing then love.graphics.line(start.x, start.y, final.x, final.y) end
end

function hit(body)
  body:applyForce((start.x - final.x) * 5, (start.y - final.y) * 5) 
end


return Table
