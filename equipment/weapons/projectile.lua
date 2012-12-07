projectile = class:new()

-- Normally we should load a config file for a weapon, but since this is love2d and lua,
-- we can just hard code some stuff for testing.
function projectile:init(name, parent)
	self.name = name
	self.parent = parent
	assert(loadfile("lovely-nemesis/equipment/weapons/configs/"..name..".lua"))
end