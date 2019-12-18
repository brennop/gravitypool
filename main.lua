Object = require 'libraries/classic'
M = require 'libraries/moses'
vector = require 'libraries/vector'
local moonshine = require 'libraries/moonshine'
local Table = require 'objects/Table'

-- global variable for debug displaying
debug = {}
shader_code = [[
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords){
  vec4 pixel = Texel(texture, texture_coords);
  float b = (pixel.r + pixel.b + pixel.g )/3.0;
  vec4 outColor = pixel * b;
  return vec4(outColor) ;
}
]]

blur_code = [[
extern vec2 screen;
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords){
  vec4 iColor = vec4(0.0);
  vec2 off1 = vec2(1.3846153846);
  vec2 off2 = vec2(3.2307692308);
  iColor += Texel(texture, texture_coords) * 0.29411764705882354;
  iColor += Texel(texture, texture_coords + (off1 / screen)) * 0.3162162162;
  iColor += Texel(texture, texture_coords - (off1 / screen)) * 0.3162162162;
  iColor += Texel(texture, texture_coords + (off2 / screen)) * 0.0702702703;
  iColor += Texel(texture, texture_coords - (off2 / screen)) * 0.0702702703;
  return iColor * color;
}
]]

function love.load()
  scene = Table()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setBackgroundColor(8/255, 2/255, 22/255, 1)
  bloom = moonshine(moonshine.effects.glow)
  bloom.glow.strength = 12
  bloom.glow.min_luma = 0.4

  -- draws background starfield
  starfield = love.graphics.newCanvas()
  starShader = love.graphics.newShader('shaders/starfield.glsl')
  starShader:send("screen", {love.graphics:getWidth(), love.graphics:getHeight()})
  love.graphics.setCanvas(starfield)
  love.graphics.setShader(starShader) 
  love.graphics.draw(love.graphics.newCanvas())
  love.graphics.setShader()
  love.graphics.setCanvas()

  shader = love.graphics.newShader(shader_code)
  blur = love.graphics.newShader(blur_code)
  blur:send("screen", {love.graphics:getWidth(), love.graphics:getHeight()})
end

function love.update(dt)
  scene:update(dt)
end

function love.draw()
  love.graphics.setShader(blur)
  love.graphics.draw(starfield)

  scene:draw()

  for index,value in ipairs(debug) do
    love.graphics.print(value, 10, 10 + index*10)
  end
  love.graphics.setShader()
end
