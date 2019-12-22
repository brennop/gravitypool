local Blackhole = Object:extend()

local shader_code = [[
extern vec2 pos;
vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ) {
  if(length(texture_coords - pos) < 1)
    return color;
  else
    return vec4(0.0);
}
]]

function Blackhole:new(world, x, y, r, m)
  self.body = love.physics.newBody(world, x, y)
  self.shape = love.physics.newCircleShape(r)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData('blackhole')
  self.mass = m
  self.radius = r

  self.shader = love.graphics.newShader(shader_code)
  self.shader:send("pos", {x / love.graphics:getWidth(), y/love.graphics:getHeight()})
  self.canvas = love.graphics.newCanvas()
end

function Blackhole:update(dt)
end

function Blackhole:draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.setShader(self.shader)
  love.graphics.setShader()
end

return Blackhole

