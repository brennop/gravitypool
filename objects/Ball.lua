local Ball = Object:extend()

local colors = {white = {1, 1, 1}, yellow = {0.8, 0.7, 0}, red = {0.9, 0.1, 0}}

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
end

function Ball:update(dt)
end

function Ball:draw()
  love.graphics.setColor(self.color)
  love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

return Ball
