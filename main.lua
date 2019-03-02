-----------------------------------------------------------------------------------------
-- main.lua
-----------------------------------------------------------------------------------------
local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

-- Create enimes
math.randomseed(os.time())

local sheetOptions = {
  frames = {
    {
      x = 0,
      y = 0,
      width = 102,
      heigh = 85
    },{
      x = 0,
      y = 85,
      width = 90,
      height = 97    
    }, {
      x = 0,
      y = 168,
      width = 100,
      height = 97
    }, {
      x = 0,
      y = 265,
      width = 98,
      height = 79
    }, {
      x = 98,
      y = 265,
      width = 14,
      height = 40
    }
  },
}

local objectSheet = graphics.newImageSheet("./img/gameObjects.png", sheetOptions)

local lives = 3
local score = 0
local died = false

local asteroidsTable = {}

local ship
local gameLoopTimer
local livesText
local scoreText

-- Create layers
local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

-- Create a background
local bg = display.newImageRect(backGroup, "./img/background.png", 800, 1400)
bg.x = display.contentCenterX
bg.y = display.contentCenterY

-- Create a ship
ship = display.newImageRect( mainGroup, objectSheet, 4, 98, 79 )
ship.x = display.contentCenterX
ship.y = display.contentHeight - 100
physics.addBody( ship, { radius=30, isSensor=true } )
ship.myName = "ship"

-- Set display score and lives
livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 36 )
scoreText = display.newText( uiGroup, "Score: " .. score, 400, 80, native.systemFont, 36 )

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Refresh text datas
local function updateText()
  livesText.text = "Lives: " .. lives
  scoreText.text = "Score: " .. score
end

--[[
  Create asteroids an define position, rotation and origin moviemnt
]]--
local function createAsteroid()
  -- Create asteroid
  local newAsteroid = display.newImageRect(mainGroup, objectSheet, 1, 102, 85)
  -- Input on tableAsteroids
  table.insert(asteroidsTable, newAsteroid)
  -- Declarated here like the physics comportaments
  physics.addBody(newAsteroid, "dynamic", { radious = 40, bounce = 0.8 })
  -- define name for this
  newAsteroid.name = "asteroid"

  -- Declarate the position started
  local whereFrom = math.random(3)

  if (whereFrom == 1) then
    -- From the Left
    newAsteroid.x = -60
    newAsteroid.y = math.random(500)
    newAsteroid:setLinearVelocity(math.random(40,120), math.random(20,60))
  elseif (whereFrom == 2) then
    -- From the Top
    newAsteroid.x = math.random( display.contentWidth )
    newAsteroid.y = -60
    newAsteroid:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
  elseif (whereFrom == 3) then
    -- From the Right
    newAsteroid.x = display.contentWidth + 60
    newAsteroid.y = math.random( 500 )
    newAsteroid:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
  end

  -- Add rotation
  newAsteroid:applyTorque(math.random( -6,6 ))
end

--[[
  Show lasers
]]--
local function fireLaser()
  -- Create a laser
  local newLaser = display.newImageRect( mainGroup, objectSheet, 5, 14, 40 )
  physics.addBody( newLaser, "dynamic", { isSensor = true } )
  newLaser.isBullet = true
  newLaser.myName = "laser"

  -- Start laser by ship
  newLaser.x = ship.x
  newLaser.y = ship.y
  -- To bottom of ship
  newLaser:toBack()

  -- Frequency to display the lasers
  transition.to(newLaser, { 
    y = -40, 
    time = 500, 
    onComplete = function() 
      display.remove( newLaser )
    end 
  })
end

-- Listiner to shot a laser
ship:addEventListener( "tap", fireLaser )

--[[
  Moving ship
]]--
local function dragShip( event )
  local ship = event.target
  local phase = event.phase

  if ("began" == phase) then
    -- Set touch focus on the ship
    display.currentStage:setFocus(ship)
    -- Store initial offset position
    ship.touchOffsetX = event.x - ship.x
    ship.touchOffsetY = event.y - ship.y
  elseif ( "moved" == phase ) then
    -- Move the ship to the new touch position
    ship.x = event.x - ship.touchOffsetX
    ship.y = event.y - ship.touchOffsetY
  elseif ( "ended" == phase or "cancelled" == phase ) then
    -- Release touch focus on the ship
    display.currentStage:setFocus( nil )
  end

  -- Prevents touch propagation to underlying objects
  return true 
end

-- Listiner to move a ship
ship:addEventListener( "touch", dragShip )
