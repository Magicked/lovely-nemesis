tile = class:new()

function tile:init(x, y, w, h)
	self.body = love.physics.newBody(world, x/2, y/2, "static")
	self.shape = love.physics.newRectangleShape(w, h)
	self.fixture = love.physics.newFixture(self.body, self.shape)
end

function tile:draw()
	love.graphics.setColor(72, 160, 14)
	love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints())) 
end