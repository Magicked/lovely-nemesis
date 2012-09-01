function love.load()
	require "class"
	require "scenes/game"
	require "utilities/utils"

	defaultVideoSettings()
	
	scene = game:new()
end

function love.update(dt)
	dt = math.min(dt, .5)	-- prevent overly large dt values
	scene:update(dt)
end

function love.draw()
	scene:draw()
end

function love.keypressed(key, unicode)
	scene:keypressed(key, unicode)
end