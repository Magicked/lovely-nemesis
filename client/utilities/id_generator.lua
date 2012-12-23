id_generator = class:new()

function id_generator:init()
	self.current_id = 0
end

function id_generator:getID()
	self.current_id = self.current_id + 1
	return self.current_id
end