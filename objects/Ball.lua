local Ball = Object:extend()

function Ball:new(world,x,y,r )
  self.body = love.physics.newBody(world, x, y, 'dynamic')
  self.body:setLinearDamping(0.7)
  self.shape = love.physics.newCircleShape(r)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setRestitution(0.8)
end

function Ball:update(dt)
end

function Ball:draw()
  love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

return Ball
