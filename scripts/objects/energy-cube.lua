-- ENERGY CUBE OBJECT --

-- Create the Energy Cube base Object --
EC = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	spriteID = 0,
	consumption = 0,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil
}

-- Constructor --
function EC:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = EC
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
	-- Draw the Sprite --
	t.spriteID = rendering.draw_sprite{sprite="EnergyCubeMK1Sprite0", x_scale=1/7, y_scale=1/7, target=object, surface=object.surface, target_offset={0, -0.3}, render_layer=131}
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function EC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = EC
	setmetatable(object, mt)
end

-- Destructor --
function EC:remove()
	-- Destroy the Sprite --
	rendering.destroy(self.spriteID)
	-- Remove from the Update System --
	UpSys.removeObj(self)
	-- Remove from the Data Network --
	if self.dataNetwork ~= nil and getmetatable(self.dataNetwork) ~= nil then
		self.dataNetwork:removeObject(self)
	end
end

-- Is valid --
function EC:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function EC:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end

	-- Try to find a connected Data Network --
	local obj = Util.getConnectedDN(self)
	if obj ~= nil and valid(obj.dataNetwork) then
		self.dataNetwork = obj.dataNetwork
		self.dataNetwork:addObject(self)
	else
		if valid(self.dataNetwork) then
			self.dataNetwork:removeObject(self)
		end
		self.dataNetwork = nil
	end
	
	-- Update the Sprite --
	local spriteNumber = math.ceil(self.ent.energy/self.ent.prototype.electric_energy_source_prototype.buffer_capacity*10)
	rendering.destroy(self.spriteID)
	self.spriteID = rendering.draw_sprite{sprite="EnergyCubeMK1Sprite" .. spriteNumber, x_scale=1/7, y_scale=1/7, target=self.ent, surface=self.ent.surface, target_offset={0, -0.3}, render_layer=131}
end


-- Tooltip Infos --
-- function EC:getTooltipInfos(GUI)
-- end






















