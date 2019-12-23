Object = require 'libraries/classic'
M = require 'libraries/moses'
vector = require 'libraries/vector'
local moonshine = require 'libraries/moonshine'
local Table = require 'objects/Table'
local blackholes = require 'shaders/blackhole'

-- global variable for debug displaying
debug = {}

function love.load()
  scene = Table()
  love.graphics.setColor(255, 255, 255)
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

  -- TODO: rename this
  -- canvas to draw blackholes
  canvas = love.graphics.newCanvas()
end

function love.update(dt)
  scene:update(dt)
end

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  -- bloom(function() 
    love.graphics.draw(starfield)
  -- end)

  scene:draw()
  love.graphics.setCanvas()

  love.graphics.draw(blackholes(canvas))

  for index,value in ipairs(debug) do
    love.graphics.print(value, 10, 10 + index*10)
  end
end
