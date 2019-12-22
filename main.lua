Object = require 'libraries/classic'
M = require 'libraries/moses'
vector = require 'libraries/vector'
local moonshine = require 'libraries/moonshine'
local Table = require 'objects/Table'

-- global variable for debug displaying
debug = {}

local shader_code = [[
extern vec2 pos;
extern vec2 ratio;
vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ) {
  vec2 offset = texture_coords - pos;
  float rad = length(offset/ratio);
  float deformation = 1/pow(rad*pow(3, 0.5), 2) * 0.0015 * 2;
  offset *= (1-deformation);
  offset += pos;
  return Texel(tex, offset);
}
]]

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

  shader = love.graphics.newShader(shader_code)
  shader:send("ratio", {love.graphics:getHeight() / love.graphics:getWidth(), 1})
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

  love.graphics.setShader(shader)
  shader:send("pos", {0.5, 0.5})
  love.graphics.draw(canvas)
  love.graphics.setShader()

  for index,value in ipairs(debug) do
    love.graphics.print(value, 10, 10 + index*10)
  end
end
