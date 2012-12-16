require "class"
entity = class:new()

function entity:init(id)
	self.x = 0
	self.y = 0
	self.angle = 0
	self.forcex = 0
	self.forcey = 0
	self.id = id
	self.name = "player"..id
end

function entity:set_position(x, y)
	self.x = x
	self.y = y
end

function entity:set_name(name)
	self.name = name
end

function entity:set_angle(a)
	self.angle = a
end

function entity:set_force(fx, fy)
	self.forcex = fx
	self.forcey = fy
end

function entity:fire_weapon(w_type, x, y, angle, forcex, forcey)
	return nil
end