require "class"
entity = class:new()

function entity:init(id)
	self.x = 0
	self.y = 0
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