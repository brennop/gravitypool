Object = require 'libraries/classic'
M = require 'libraries/moses'
vector = require 'libraries/vector'
local Table = require 'objects/Table'

-- global variable for debug displaying
debug = {}

function love.load()
  scene = Table()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setBackgroundColor(4/255, 0/255, 10/255, 1)
end

function love.update(dt)
  scene:update(dt)
end

function love.draw()
  for index,value in ipairs(debug) do
    love.graphics.print(value, 10, 10 + index*10)
  end

  scene:draw()
end
