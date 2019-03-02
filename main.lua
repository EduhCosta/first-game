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

local objectSheet = graphics.newImageSheet("gameObjects.png", sheetOptions)

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
local bg = display.newImageRect(backGroup, "background.png", 800, 1400)
bg.x = display.contentCenterX
bg.y = display.contentCenterY

-- Create a nave
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