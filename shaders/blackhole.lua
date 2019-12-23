local withBlackholes = {} 

local blackholeShader = love.graphics.newShader('shaders/blackhole.glsl')
local nextCanvas = love.graphics.newCanvas()
blackholeShader:send("ratio", {love.graphics:getHeight() / love.graphics:getWidth(), 1})

function withBlackholes(canvas)
  for _, bh in ipairs(M.last(bodies, 4)) do
    love.graphics.setCanvas(nextCanvas)
    love.graphics.setShader(blackholeShader)
    blackholeShader:send("pos", {bh.body:getX()/love.graphics.getWidth(), bh.body:getY()/love.graphics.getHeight()})
    love.graphics.draw(canvas)
    love.graphics.setShader()
    love.graphics.setCanvas()

    love.graphics.setCanvas(canvas)
    love.graphics.draw(nextCanvas)
    love.graphics.setCanvas()
  end
  return canvas
end

return withBlackholes
