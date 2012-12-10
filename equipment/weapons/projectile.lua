projectile = class:new()

-- Normally we should load a config file for a weapon, but since this is love2d and lua,
-- we can just hard code some stuff for testing.
function projectile:init(name, parent)
	self.name = name
	self.parent = parent
	loaded_chunk = assert(loadfile("lovely-nemesis/equipment/weapons/configs/"..name..".lua"))
	loaded_chunk()
	self.last_fire = 0
end

function projectile:fire(dt)
	local current_time = love.timer.getMicroTime()
	if current_time - self.last_fire > 1 / weapons.config.proj_tiny_auto.rof then
		self.last_fire = current_time
		--local bullet = bullet:new(xstart, ystart, tx, ty)
		--bullet:ignore_target(self.parent)
    	--table.insert(ent.projectile.bullet, bullet)
	end
end