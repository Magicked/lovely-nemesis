player = class:new()

function player:init(x, y)
	self.x = x
    self.y = y
    self.width = 16
    self.height = 32
    self.var_thrust = 200
    self.max_rotation = 1 -- radians/sec
    self:initkeys()

    -- Create our physics objects
	self.xloc = x + self.width / 2
    self.yloc = y + self.height / 2
	self.body = love.physics.newBody(world, xloc, yloc, "dynamic")
	self.shape = love.physics.newRectangleShape(self.width, self.height)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.fixture:setRestitution(0.1)

end

function player:update(dt)
	self:check_keyboard()
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

    if self.keytable.thrust and not self.keytable.brake then
    	self:thrust(dt)
    end
    if self.keytable.brake then
    	self:brake(dt)
    end
    if self.keytable.rotate_left and not self.keytable.rotate_right then
    	self:rotate_left(dt)
    end
    if self.keytable.rotate_right and not self.keytable.rotate_left then
    	self:rotate_right(dt)
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

function player:check_keyboard()
	for k,v in ipairs(self.keytable) do
		v = false
	end

	self.keytable.thrust = false
	if love.keyboard.isDown("w") then
		self.keytable.thrust = true
	end
	if love.keyboard.isDown("a") then
		self.keytable.rotate_left = true
	end
	if love.keyboard.isDown("s") then
		self.keytable.brake = true
	end
	if love.keyboard.isDown("d") then
		self.keytable.rotate_right = true
	end
end

function player:keypressed(key)

end

function player:brake(dt)

end

function player:thrust(dt)
	local vx = math.cos(self.body:getAngle())
	local vy = math.sin(self.body:getAngle())
	self.body:applyForce(self.var_thrust * vx * dt, self.var_thrust * vy * dt)
end

function player:rotate_left(dt)
	self.body:setAngle(self.body:getAngle() - self.max_rotation * dt)
	--self.body:applyForce(-self.speed * dt, 0)
end

function player:rotate_right(dt)
	self.body:setAngle(self.body:getAngle() + self.max_rotation * dt)
	--self.body:applyForce(self.speed * dt, 0)
end

function player:getCenterX()
	--return self.body:getX()
	return self.xloc
end

function player:getCenterY()
	--return self.body:getY()
	return self.yloc
end

function player:initkeys()
	self.keytable = {}
	self.keytable.rotate_right = false
	self.keytable.rotate_left = false
	self.keytable.thrust = false
	self.keytable.brake = false
	self.keytable.fire = false
end