local Ball = Object:extend()

local colors = {white = {1, 1, 1}, yellow = {0.9, 0.8, 0}, red = {0.95, 0.12, 0}}

function Ball:new(world, x, y, r, m, t)
  self.body = love.physics.newBody(world, x, y, 'dynamic')
  self.body:setLinearDamping(0.7)
  self.body:setMass(m)
  self.body:setBullet(true)
  self.shape = love.physics.newCircleShape(r)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(t)
  self.fixture:setRestitution(0.8)
  self.color = colors[t]
  self.mass = m
  self.radius = r

  self.shader = love.graphics.newShader('shaders/ball.glsl')
  self.canvas = love.graphics.newCanvas(2*r, 2*r)
end

function Ball:update(dt)
end

function Ball:draw()
  love.graphics.setColor(self.color)
  love.graphics.setShader(self.shader)
  self.shader:send("pos", {self.body:getX() / love.graphics.getWidth(), self.body:getY() / love.graphics.getHeight()})
  love.graphics.draw(self.canvas, self.body:getX() - self.radius, self.body:getY() - self.radius)
  love.graphics.setShader()
end

return Ball
