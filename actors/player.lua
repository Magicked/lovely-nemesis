player = class:new()

function player:init(x, y)
	self.x = x
    self.y = y
    self.width = 16
    self.height = 32
    self.speed = 1000

    -- Create our physics objects
	self.xloc = x + self.width / 2
    self.yloc = y + self.height / 2
	self.body = love.physics.newBody(world, xloc, yloc, "dynamic")
	self.shape = love.physics.newRectangleShape(self.width, self.height)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.fixture:setRestitution(0.1)

    self.key = {
		up = "up" or "w",
		down = "down" or "s",
		left = "left" or "a",
		right = "right" or "d",
		jump = "space"
	}
end

function player:update(dt)
	--local curX = self.body:getX()
	--local curY = self.body:getY()
	if love.mouse.isDown("l") then
		local xstart = self.body:getX()
		local ystart = self.body:getY()
		local tx = love.mouse.getX() - camera:getTransX()
		local ty = love.mouse.getY() - camera:getTransY()
		if tx > xstart then
			xstart = xstart + self.width / 2 + 2
		else
			xstart = xstart - self.width / 2 - 2
		end
		if ty > ystart then
			ystart = ystart + self.height / 2 + 2
		else
			ystart = ystart - self.height / 2 - 2
		end
		local bullet = bullet:new(xstart, ystart, tx, ty)
	    table.insert(ent.projectile.bullet, bullet)
    end
end

function player:draw()
	love.graphics.setColor(255, 255, 255)
	local ox = self.width / 2
	local oy = self.height / 2
	--love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle(), 1, 1, ox, oy, 0, 0)
	love.graphics.setColor(255, 255, 0)
	love.graphics.rectangle("fill", self.body:getX() - ox, self.body:getY() - oy, self.width, self.height)
	--love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, 0, 0, 0, 0)
end

function player:keypressed(key)
	if key == self.key.down then
		self:down()
	end

	if key == self.key.up then
		self:up()
	end

	if key == self.key.left then
		self:left()
	end

	if key == self.key.right then
		self:right()
	end
end

function player:down()

end

function player:up()

end

function player:left()
	self.body:applyForce(-self.speed, 0)
end

function player:right()
	self.body:applyForce(self.speed, 0)
end

function player:getCenterX()
	--return self.body:getX()
	return self.xloc
end

function player:getCenterY()
	--return self.body:getY()
	return self.yloc
end

function initkeys()
	self.keytable = {}
	self.keytable.left = false
	self.keytable.right = false
	self.keytable.up = false
	self.keytable.down = false
	self.keytable.space = false
end