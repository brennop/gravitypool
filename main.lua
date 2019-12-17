Object = require 'libraries/classic'
M = require 'libraries/moses'
vector = require 'libraries/vector'
local Table = require 'objects/Table'

-- global variable for debug displaying
debug = {}
local nStars = 350

function love.load()
  scene = Table()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setBackgroundColor(8/255, 2/255, 22/255, 1)
  stars = {}
  for i = 1, nStars, 1 do
    stars[i] = {x = math.random(0, love.graphics:getWidth()), y = math.random(0, love.graphics:getHeight()), r = math.random()}
  end
end

function love.update(dt)
  scene:update(dt)
end

function love.draw()

  for _,star in ipairs(stars) do
    love.graphics.circle("fill", star.x, star.y, star.r)
  end

  scene:draw()

  for index,value in ipairs(debug) do
    love.graphics.print(value, 10, 10 + index*10)
  end
end
