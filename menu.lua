
local composer = require( "composer" )

-- Declarated this script like a Scene
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Redirect methods
-- -----------------------------------------------------------------------------------
local function gotoGame ()
  composer.gotoScene("game")
end

local function gotoHighScores () 
  composer.gotoScene("heighscores")
end

-- -----------------------------------------------------------------------------------
-- Lifecycle of scene
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
  local sceneGroup = self.view
  -- Define background 
	local background = display.newImageRect( sceneGroup, "img/background.png", 800, 1400 )
  background.x = display.contentCenterX
  background.y = display.contentCenterY
  -- Define title
  local title = display.newImageRect( sceneGroup, "img/title.png", 500, 80 )
  title.x = display.contentCenterX
  title.y = 200
  -- Create a play button
  local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 700, native.systemFont, 44 )
  playButton:setFillColor( 0.82, 0.86, 1 )
  -- Create a highscore button
  local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, 810, native.systemFont, 44 )
  highScoresButton:setFillColor( 0.75, 0.78, 1 )
  -- Add events to buttons
  playButton:addEventListener("tap", gotoGame)
  highScoresButton:addEventListener("tap", gotoHighScores)
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
