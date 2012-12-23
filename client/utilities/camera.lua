camera = class:new()

function camera:init(x, y)
	self.x = x
	self.y = y
	self.transX = x
	self.transY = y
	self.zoom = {
		x = 1,
		y = 1,
		modifier = 1
	}
	following = {}
	print "Initializing camera"
end

function camera:draw()
	love.graphics.scale(self.zoom.x * self.zoom.modifier, self.zoom.y * self.zoom.modifier)
	transX = -self.x
	transY = -self.y
	if following ~= nil then
		transX = -(following:getCenterX() - screen.width / 2)
		transY = -(following:getCenterY() - screen.height / 2)
	end
	if self.zoom.x ~= 1 or self.zoom.y ~= 1 or self.zoom.modifier ~= 1 then
		transX = transX + ((screen.width - (screen.width * self.zoom.x * self.zoom.modifier)) / 2)
		transY = transY + ((screen.height - (screen.height * self.zoom.y * self.zoom.modifier)) / 2)
	end
	
	love.graphics.translate(transX, transY)
end

function camera:setFollow(object)
	following = object
end

function camera:getTransX()
	return transX
end

function camera:getTransY()
	return transY
end