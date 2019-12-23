local Blackhole = Object:extend()

function Blackhole:new(world, x, y, r, m)
  self.body = love.physics.newBody(world, x, y)
  self.shape = love.physics.newCircleShape(r)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData('blackhole')
  self.fixture:setFilterData(3, 2, 0)
  self.mass = m
end

function Blackhole:update(dt)
end

function Blackhole:draw()
  love.graphics.setColor(0, 0, 0)
  -- love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

return Blackhole

