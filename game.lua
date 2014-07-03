----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
function scene:Despawn(event)
	if not tonumber(self.Count) or self.Count <= 1 then
		self:dispatchEvent{name = 'Game'; action = 'stop'}
		print("Stop")
	else
		self.Count = self.Count - 1
	end
end
 
function scene:create( event )
	local sceneGroup = self.view
	self.World = require "world" {
		Backdrop = "images/exterior-parallaxBG1.png",
		--Tile = "images/wall.png";
		Inhabitants = {
			bat = require "bat"
		}
	}
	sceneGroup:insert(self.World)
	self.World:addEventListener('Death', self)
	self.World:addEventListener('Despawn', self)
	self:addEventListener('Game', self.World)
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		self.ScoreTotal = 0
		self.StartingCount = 10
		self.Count = self.StartingCount
		self:dispatchEvent{name = 'Game'; action = 'start', duration = (self.Count + 1) * 500}
		for i=1,self.Count do
			local x, y = 0, display.contentHeight
			timer.performWithDelay(i * 1500, function(...) self.World:Spawn{kind = 'bat', x = x, y = y, 'brown'} end)
		end 
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end


function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene