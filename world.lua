local function start(self, duration)
	if self.Backdrop then
		--self.Backdrop:setReferencePoint(display.BottomCenterReferencePoint)
		self.Backdrop.anchorX, self.Backdrop.anchorY = .5, 1
		local scale = (display.contentHeight * 2) / self.Backdrop.height
		self.Backdrop.xScale, self.Backdrop.yScale = scale, scale
		self.Backdrop.x, self.Backdrop.y = display.contentCenterX, display.contentHeight
		self.Backdrop.Scroll = transition.to(self.Backdrop, {time=duration, delta = true; y = display.contentHeight})
	end
	if self.StartBackground then
		self:StartBackground()
	end
end
local function stop(self)
	transition.cancel(self.Backdrop.Scroll)
	if self.Scroll then
		for i = self.Scroll.numChildren, 1, -1 do
			transition.cancel(self.Scroll[i].Shift)
			self.Scroll:remove(i)
		end
	end
end

return function(options)
	local self = display.newGroup()
	if options.Backdrop then
		self.Backdrop = display.newImage(self, options.Backdrop, 0, 0)
	end
	local tilePath = options.Tile
	if tilePath then
		self.Scroll = display.newGroup(); self:insert(self.Scroll)
		function self:StartBackground()
			local tile = display.newImage(self.Scroll, tilePath, display.contentWidth, 0)
			tile.Shift = transition.to(tile, {time = 4000, delta = true, onComplete = function(...) return self:StartBackground() end; x = -display.contentWidth, y = display.contentHeight})
		end
	end
	self.Inhabitants = options.Inhabitants
	self.Creatures = display.newGroup(); self:insert(self.Creatures)
	
	function self:Game(event)
		if event.action == 'start' then
			start(self, event.duration)
		elseif event.action == 'stop' then
			stop(self)
		end
	end
	
	local function retransmit(...)
		self:dispatchEvent(...)
	end
	function self:remove(event)
		self:dispatchEvent{name = 'Despawn'; unit = event.target}
	end
	
	function self:Spawn(info)	
		local newSpawn = self.Inhabitants[info.kind](self.Creatures, info.x, info.y, unpack(info))
		newSpawn:addEventListener('Death', retransmit)
		newSpawn:addEventListener('remove', self)
	end
	return self
end