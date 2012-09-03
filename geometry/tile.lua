tile = class:new()

function tile:init(x, y, w, h)
	self.x = x
	self.y = y
	self.width = w
	self.height = h
	--self.body = love.physics.newBody(world, x + w/2, y + h/2, "static")
	--self.shape = love.physics.newRectangleShape(w, h)
	--self.fixture = love.physics.newFixture(self.body, self.shape)
	-- variable used in checkedForCollision
	self.cchecked = false
end

function tile:draw()
	love.graphics.setColor(72, 160, 14)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height) 
end

function tile:isInternal()

end

function tile:checkedForCollision(checked)
	if checked == nil then
		return self.cchecked
	end
	self.cchecked = checked
end