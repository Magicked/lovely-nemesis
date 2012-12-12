player = class:new()

function player:init(x, y)
	require "equipment/weapons/projectile"

	self.x = x
    self.y = y
 
    self.var_thrust = 200
    self.var_brake = 5
    self.max_rotation = 1 -- radians/sec
    self:initkeys()

    self.image = love.graphics.newImage("/images/spaceships/tiny_ship.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.weapons = {}
    local weapon = projectile:new("proj_tiny_auto", self)
    table.insert(self.weapons, weapon)
    self.selected_weapon = self.weapons[1]

    self.id = id_generator:getID()

    -- Create our physics objects
	self.xloc = x + self.width / 2
    self.yloc = y + self.height / 2
	self.body = love.physics.newBody(world, xloc, yloc, "dynamic")
	self.shape = love.physics.newRectangleShape(self.width, self.height)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.fixture:setRestitution(0.1)
	self.body:setFixedRotation(true)

	self.userData = {}
	self.userData['id'] = self.id
	self.userData['name'] = "player"
	self.fixture:setUserData(self.userData)
end

function player:update(dt)
	self:check_keyboard()
	--local curX = self.body:getX()
	--local curY = self.body:getY()

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
    if self.keytable.fire then
    	self:fire(dt)
    end
end

function player:draw()
	love.graphics.setColor(255, 255, 255)
	local ox = self.width / 2
	local oy = self.height / 2
	--love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle(), 1, 1, ox, oy, 0, 0)
	--love.graphics.setColor(255, 255, 0)
	love.graphics.draw(self.image, self.body:getX() - ox, self.body:getY() - oy, self.body:getAngle(), 1, 1, 0, 0, 0, 0)
	--love.graphics.rectangle("fill", self.body:getX() - ox, self.body:getY() - oy, self.width, self.height)
	--love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, 0, 0, 0, 0)
end

function player:check_keyboard()
	for _,key in pairs(self.keys) do
		self.keytable[key] = false
	end

	--self.keytable.thrust = false
	if love.keyboard.isDown("w") then
		self.keytable["thrust"] = true
	end
	if love.keyboard.isDown("a") then
		self.keytable["rotate_left"] = true
	end
	if love.keyboard.isDown("s") then
		self.keytable["brake"] = true
	end
	if love.keyboard.isDown("d") then
		self.keytable["rotate_right"] = true
	end
	if love.keyboard.isDown(" ") then
		self.keytable["fire"] = true
	end
end

function player:keypressed(key)

end

function player:brake(dt)
	local vx, vy = self.body:getLinearVelocity()
	bx = -vx * self.var_brake * dt
	by = -vy * self.var_brake * dt
	if math.abs(bx) < .5 and math.abs(by) < .5 then
		self.body:setLinearVelocity(0, 0)
	else
		self.body:applyForce(bx, by)
	end
end

function player:thrust(dt)
	local vx = math.cos(self.body:getAngle())
	local vy = math.sin(self.body:getAngle())
	self.body:applyForce(self.var_thrust * vx * dt, self.var_thrust * vy * dt)
end

function player:rotate_left(dt)
	self.body:setAngle(self.body:getAngle() - self.max_rotation * dt)
end

function player:rotate_right(dt)
	self.body:setAngle(self.body:getAngle() + self.max_rotation * dt)
end

function player:fire(dt)
	for k,v in pairs(self.weapons) do
		local sweap = self.weapons[k]
		sweap:fire(dt)
	end
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
	--local bullet = bullet:new(xstart, ystart, tx, ty)
    --table.insert(ent.projectile.bullet, bullet)
end

function player:getCenterX()
	return self.body:getX()
	--return self.xloc
end

function player:getCenterY()
	return self.body:getY()
	--return self.yloc
end

function player:initkeys()
	self.keytable = {}
	self.keys = { "rotate_right", "rotate_left", "thrust", "brake", "fire" }

	for _,key in pairs(self.keys) do
		self.keytable[key] = false
	end
end

function player:getID()
	return self.id
end