Object = require 'libraries/classic'
M = require 'libraries/moses'
vector = require 'libraries/vector'
local moonshine = require 'libraries/moonshine'
local Table = require 'objects/Table'

-- global variable for debug displaying
debug = {}
local nStars = 350

function love.load()
  scene = Table()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setBackgroundColor(8/255, 2/255, 22/255, 1)
  bloom = moonshine(moonshine.effects.glow)
  bloom.glow.strength = 12
  stars = {}
  for i = 1, nStars, 1 do
    stars[i] = {x = math.random(0, love.graphics:getWidth()), y = math.random(0, love.graphics:getHeight()), r = math.random()*1.5}
  end
  starCanvas = love.graphics.newCanvas()
  love.graphics.setCanvas(starCanvas)
      love.graphics.setColor(1,1,1,0.7)
      for _,star in ipairs(stars) do
        love.graphics.circle("fill", star.x, star.y, star.r)
      end
  love.graphics.setCanvas()
  bloom.disable("glow")
end

function love.update(dt)
  scene:update(dt)
end

function love.draw()
  bloom(function()
    love.graphics.draw(starCanvas)
  end)
  scene:draw()

  for index,value in ipairs(debug) do
    love.graphics.print(value, 10, 10 + index*10)
  end
end
