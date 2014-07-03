local spriteSheet = graphics.newImageSheet("images/bat.png", {width=32, height=48, numFrames=12; sheetContentWidth=192, sheetContentHeight=96})

local batInfo = {
	brown = {
		{
			name = 'sleep';
			start = 7,
			count = 1,
		},
		{
			name = 'fly';
			start = 8,
			count = 5,
			time = 750,
		}
	},
	black = {
		{
			name = 'sleep';
			start = 1,
			count = 1,
		},
		{
			name = 'fly';
			start = 2,
			count = 5,
			time = 750,
		},
	}
}

local function clean(self)
	self:dispatchEvent{name = 'remove'; target = self, object = self}
	return display.remove(self)
end

local function touchResponse(self, event)
	self:dispatchEvent{name='Death'; unit = self, source = 'player'}
	self:removeEventListener('tap', self)
end

local function mobDied(self, event)
	self.alpha = 0.3
end

local function flap(self)
	self:setSequence('fly')
	return self:play()
end

return function(parent, x, y, kind)
	local self = display.newSprite(parent, spriteSheet, batInfo[kind])
	self.tap = touchResponse
	self:addEventListener('tap', self)
	self.Death = mobDied
	self:addEventListener('Death', self)
	--self:setReferencePoint(display.CenterRightReferencePoint)
	self.anchorX, self.anchorY = 1, .5	
	self.anchorX = self.anchorX * 0.75
	self.xScale, self.yScale = 2, 2
	self.x, self.y = x, y
	self.Flight = transition.to(self, {time=1500, onStart = flap, onComplete = clean, delta = true; x = display.contentWidth, y = - display.contentHeight})
	return self
end
