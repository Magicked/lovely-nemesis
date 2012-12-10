bullet = class:new()

function bullet:init(x, y, tx, ty)
	self.speed = 200
	self.x = x
	self.y = y
	self.tx = tx
	self.ty = ty
	self.ax = tx - x
	self.ay = ty - y
	self.magnitude = math.sqrt((self.ax ^ 2) + (self.ay ^ 2))
	self.xnorm = self.ax / self.magnitude
	self.ynorm = self.ay / self.magnitude
	--print ("Force: " .. self.xnorm * self.speed .. ", " .. self.ynorm * self.speed)
	-- whether the entity is alive or not
	self.alive = true
	-- timer for tracking time alive
	self.timer = 0
	-- alive_time is time in seconds
	self.alive_time = 4
	-- Radius of the circle
	self.radius = 2
	-- Create our physics objects
	self.body = love.physics.newBody(world, x + self.radius, y + self.radius, "dynamic")
	self.shape = love.physics.newCircleShape(self.radius)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.fixture:setRestitution(0.1)
	self.fixture:setUserData("Bullet")
	self.body:applyForce(self.xnorm * self.speed, self.ynorm * self.speed)
	print("Position: " .. x + self.radius .. ", " .. y + self.radius .. " -- Force: " .. self.xnorm * self.speed .. ", " .. self.ynorm * self.speed)
end

function bullet:draw()
	love.graphics.setColor(255, 0, 0)
	love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
end

function bullet:update(dt)
	if self.timer > self.alive_time then
		self.alive = false
		self.body:destroy()
	end
	self.timer = self.timer + dt
end

function bullet:isAlive()
	return self.alive
end