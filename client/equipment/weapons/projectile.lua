projectile = class:new()

-- Normally we should load a config file for a weapon, but since this is love2d and lua,
-- we can just hard code some stuff for testing.
function projectile:init(name, parent)
	self.name = name
	self.parent = parent
	loaded_chunk = assert(loadfile("client/equipment/weapons/configs/"..name..".lua"))
	loaded_chunk()
	self.last_fire = 0
end

function projectile:fire(dt)
	local current_time = love.timer.getMicroTime()
	if current_time - self.last_fire > 1 / weapons.config.proj_tiny_auto.rof then
		self.last_fire = current_time
		local xstart = self.parent.body:getX()
		local ystart = self.parent.body:getY()
		local tx = love.mouse.getX() - camera:getTransX()
		local ty = love.mouse.getY() - camera:getTransY()
		local bullet = bullet:new(xstart, ystart, tx, ty)
		bullet:ignoreTarget(self.parent:getID())
    	table.insert(ent.projectile.bullet, bullet)
	end
end