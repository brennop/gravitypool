local Ball = Object:extend()

local colors = {white = {1, 1, 1}, yellow = {0.8, 0.7, 0}, red = {0.9, 0.1, 0}}

local shader_code = [[
//extern vec2 screen; 
float levels = 3;
vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ) {
  vec3 l = vec3(0.3, -0.2, 0.7);
  float lightS = 2.0;
  vec2 uv = (texture_coords - 0.5) * 2.0;
  float radius = length(uv);
  vec3 normal = vec3(uv.x, uv.y, sqrt(1.0 - uv.x*uv.x - uv.y*uv.y));
  float ndotl = max(0.0, dot(normal, l));
  // ndotl = ndotl > 0.3 ? 1 : 0.2;
  ndotl = 1.2 - 1.0 / (1.0 + exp(20 * (ndotl - 0.2)));
  if(radius <= 1.0)
    return color * vec4(ndotl, ndotl, ndotl, 1.0) * lightS;
  else
    return vec4(0.0);
}
]]

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

  self.shader = love.graphics.newShader(shader_code)
  self.canvas = love.graphics.newCanvas(2*r, 2*r)
end

function Ball:update(dt)
end

function Ball:draw()
  love.graphics.setColor(self.color)
  love.graphics.setShader(self.shader)
  love.graphics.draw(self.canvas, self.body:getX() - self.radius, self.body:getY() - self.radius)
  love.graphics.setShader()

end

return Ball
