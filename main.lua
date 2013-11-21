-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)
physics = require "physics"
physics.start()
--physics.setGravity(0,0)
--physics.setDrawMode("debug")
local background = display.newImage("background.jpg")

local ground1 = display.newImage("ground.png")
ground1.y = 250
physics.addBody(ground1,"static",{bounce=0})
ground1.name = "ground1"
require "su"
--require "test"
