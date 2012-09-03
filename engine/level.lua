level = class:new()

function level:init()
	self.physicsBodies = {}
	self.tileGrid = {}
	for i = 0, worldTileWidth do
		self.tileGrid[i] = {}

		for j = 0, worldTileHeight do
			self.tileGrid[i][j] = nil
		end
	end
end

function level:generate()
	-- Create our tiles
	for i = 0, 20, 1 do
		local tile = tile:new(i * tileSize, 10 * tileSize, tileSize, tileSize)
		self.tileGrid[i][10] = tile
		table.insert(ent.geometry.tile, tile)
	end

	for i = 0, worldTileWidth do
		for j = 0, worldTileHeight do
			local tile = self.tileGrid[i][j]
			if tile ~= nil then
				if not tile:checkedForCollision(nil) then
					self:generateCollisionBody(i, j, 0, 0, 0, 0)
				end
			end
		end
	end
end

function level:generateCollisionBody(x, y, up_from_origin, down_from_origin, left_from_origin, right_from_origin)
	if x > worldTileWidth or x < 0 then
		return 0
	end
	if y > worldTileHeight or y < 0 then
		return 0
	end
	local tile = self.tileGrid[x][y]
	if tile == nil then
		return 0
	end
	-- If it has already been checked we need to return
	if tile:checkedForCollision(nil) then
		return 0
	end
	-- Set that we have checked this tile
	tile:checkedForCollision(true)
	-- Check to see if this is an internal tile
	local left = nil
	local right = nil
	local up = nil
	local down = nil
	if x + 1 <= worldTileWidth then
		right = self.tileGrid[x + 1][y]
	end
	if x - 1 >= 0 then
		left = self.tileGrid[x - 1][y]
	end
	if y + 1 <= worldTileHeight then
		down = self.tileGrid[x][y + 1]
	end
	if x - 1 >= 0 then
		up = self.tileGrid[x][y - 1]
	end
	if (up ~= nil) and (down ~= nil) and (left ~= nil) and (right ~= nil) then
		-- We have found a completely internal tile
		return 0
	end
	if (up == nil) and (down == nil) and (left == nil) and (right == nil) then
		-- We have found an isolated tile
		local body = love.physics.newBody(world, x + tileSize/2, y + tileSize/2, "static")
		local shape = love.physics.newRectangleShape(tileSize, tileSize)
		local fixture = love.physics.newFixture(body, shape)
		return 0
	end
	-- Now we find the external edges, and we move walk in the direction opposite those edges to generate external facing rectangles.
	-- If the distance of the walk is 0, we generate a single rectangle
	-- Start by continuing in the same direction we are headed
	if up_from_origin > 0 then
		return self:generateCollisionBody(x, y - 1, up_from_origin + 1, 0, 0, 0) + 1
	end
	if down_from_origin > 0 then
		return self:generateCollisionBody(x, y + 1, 0, down_from_origin + 1, 0, 0) + 1
	end
	if left_from_origin > 0 then
		return self:generateCollisionBody(x - 1, y, 0, 0, left_from_origin + 1, 0) + 1
	end
	if right_from_origin > 0 then
		return self:generateCollisionBody(x + 1, y, 0, 0, 0, right_from_origin + 1) + 1
	end
	local vertical_walk = 0
	local horizontal_walk = 0
	local distance_up = 0
	local distance_down = 0
	local distance_left = 0
	local distance_right = 0
	if (up == nil) then
		distance_down = self:generateCollisionBody(x, y + 1, 1, 0, 0, 0)
	end
	if (down == nil) then
		distance_up = self:generateCollisionBody(x, y - 1, 0, 1, 0, 0)
	end
	if (left == nil) then
		distance_right = self:generateCollisionBody(x + 1, y, 0, 0, 0, 1)
	end
	if (right == nil) then
		distance_left = self:generateCollisionBody(x - 1, y, 0, 0, 1, 0)
	end
	vertical_walk = 1 + distance_up + distance_down
	horizontal_walk = 1 + distance_left + distance_right
	if vertical_walk > 1 then
		local relative_y = (y - distance_up) * tileSize
		local shape = love.physics.newRectangleShape(1 * tileSize, vertical_walk * tileSize)
		local body = love.physics.newBody(world, x * tileSize + tileSize / 2, relative_y + vertical_walk * tileSize / 2, "static")
		local fixture = love.physics.newFixture(body, shape)
	elseif horizontal_walk > 1 then
		local relative_x = (x - distance_left) * tileSize
		local shape = love.physics.newRectangleShape(horizontal_walk * tileSize, 1 * tileSize)
		local body = love.physics.newBody(world, relative_x + horizontal_walk * tileSize / 2, y * tileSize + tileSize / 2, "static")
		local fixture = love.physics.newFixture(body, shape)
	end
	return 0
end