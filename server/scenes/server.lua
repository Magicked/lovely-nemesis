game = class:new()

function game:init()
	require "actors/player"
	require "projectiles/bullet"
	require "geometry/tile"
	require "utilities/camera"
	require "utilities/id_generator"

	worldMeter = 32
	tileSize = 32
	self:loadLevel() -- load the level and world before we load the player

	camera = camera:new(0, 0)
	id_generator = id_generator:new()
end

function game:update(dt)
    for k,player in ipairs(ent.actor.player) do
    	player:update(dt)
    end

	for k,bullet in ipairs(ent.projectile.bullet) do
	    bullet:update(dt)
	    -- Delete the bullet if it is no longer alive
	    if not bullet:isAlive() then
	    	table.remove(ent.projectile.bullet, k)
	    	bullet = nil
	    end
	end

	world:update(dt)
end

function game:draw()
	love.graphics.setColor(255, 255, 255)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 50, 50)
    love.graphics.print("Server is running", 50, 100)

    camera:draw()
end

function game:keypressed(key, unicode)
	
end

function game:loadLevel()
	self:loadEntTables()
	self:generateLevel()
end

function game:generateLevel()
	print("Creating new physics world")
	worldWidth = 4000000
	worldHeight = 4000000
	-- create the actual world
	world = love.physics.newWorld(0, 0, worldWidth, worldHeight)
	-- world:setGravity(0, worldMeter * 9.81)
	world:setGravity(0, 0)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	love.physics.setMeter(worldMeter)
end

function game:loadEntTables()
	print "Creating entity tables"
	ent = {
		actor = {
			player = {},
			npc = {},
		},
		projectile = {
			bullet = {},
		},
		geometry = {
			tile = {},
		},
		level = {},
	}
end

function beginContact(a, b, coll)
	if a:getUserData() ~= nil and b:getUserData() ~= nil then
		print "Checking collisions"
		aud = a:getUserData() 
    	bud = b:getUserData()
    	if aud['ignore_collisions'] and bud['id'] then
			for _,value in pairs(aud['ignore_collisions']) do
				if value == bud['id'] then
					coll:setEnabled(false)
					return nil
				end
			end
    	end
    	if bud['ignore_collisions'] and aud['id'] then
			for _,value in pairs(bud['ignore_collisions']) do
				if value == aud['id'] then
					coll:setEnabled(false)
					return nil
				end
			end
    	end
    end
	return nil
end

function endContact(a, b, coll)
	return nil
end

function preSolve(a, b, coll)
	return nil
end

function postSolve(a, b, coll)
	return nil
end