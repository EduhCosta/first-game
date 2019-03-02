
local composer = require( "composer" )
local scene = composer.newScene()

local json = require( "json" )
local scoresTable = {}
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )

-- Load all scores
local function loadScores()
  -- Verify if exists this archive
  local file = io.open(filePath, "r")
  if file then
    local contents = file:read( "*a" )
    io.close(file)
    scoresTable = json.decode(contents)
  end
  -- Case not exists content, input the table on archive
  if (scoresTable == nil or #scoresTable == 0) then
    scoresTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
  end
end

-- Save scores
local function saveScores()
  for i = #scoresTable, 11, -1 do
    table.remove(scoresTable, i)
  end
  local file = io.open(filePath, "w")
  if file then
    file:write(json.encode(scoresTable))
    io.close(file)
  end
end

-- Redirect to menu
local function gotoMenu()
  composer.gotoScene("menu", { time=800, effect="crossFade" })
end

-- -----------------------------------------------------------------------------------
-- Lifecycle of scenes
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
	local sceneGroup = self.view
  loadScores()
  table.insert(scoresTable, composer.getVariable("finalScore"))
  composer.setVariable("finalScore", 0)
  -- Auxiliar function to sort on next step
  local function compare(a, b)
    return a > b
  end
  table.sort(scoresTable, compare)
  saveScores()
  -- Create interface
  local background = display.newImageRect(sceneGroup, "img/background.png", 800, 1400)
  background.x = display.contentCenterX
  background.y = display.contentCenterY
  local highScoresHeader = display.newText(
    sceneGroup,
    "High Scores",
    display.contentCenterX,
    100,
    native.systemFont,
    44
  )
  -- Order
  for i = 1, 10 do
    if (scoresTable[i]) then
      local yPos = 150 + (i * 56)
      local rankNum = display.newText(
        sceneGroup, i .. ")",
        display.contentCenterX-50,
        yPos,
        native.systemFont,
        36
      )
      rankNum:setFillColor(0.8)
      rankNum.anchorX = 1
      local thisScore = display.newText(
        sceneGroup,
        scoresTable[i],
        display.contentCenterX-30,
        yPos,
        native.systemFont,
        36
      )
      thisScore.anchorX = 0
    end
  end
  -- Go to menu
  local menuButton = display.newText(
    sceneGroup,
    "Menu",
    display.contentCenterX,
    810,
    native.systemFont,
    44
  )
  menuButton:setFillColor(0.75, 0.78, 1)
  menuButton:addEventListener("tap", gotoMenu)
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
    composer.removeScene( "highscores" )
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
