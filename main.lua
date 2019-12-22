Object = require 'libraries/classic'
M = require 'libraries/moses'
vector = require 'libraries/vector'
local moonshine = require 'libraries/moonshine'
local Table = require 'objects/Table'

-- global variable for debug displaying
debug = {}

function love.load()
  scene = Table()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setBackgroundColor(8/255, 2/255, 22/255, 1)
  bloom = moonshine(moonshine.effects.glow)
  bloom.glow.strength = 2

  -- draws background starfield
  starfield = love.graphics.newCanvas()
  starShader = love.graphics.newShader('shaders/starfield.glsl')
  love.graphics.setCanvas(starfield)
  love.graphics.setShader(starShader) 
  love.graphics.draw(love.graphics.newCanvas())
  love.graphics.setShader()
  love.graphics.setCanvas()
end

function love.update(dt)
  scene:update(dt)
end

function love.draw()
  bloom(function() 
    love.graphics.draw(starfield)
  end)

  scene:draw()

  for index,value in ipairs(debug) do
    love.graphics.print(value, 10, 10 + index*10)
  end
end
