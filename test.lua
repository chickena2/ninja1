local widget 	= require "widget"

local su 		= require "su"

local function throw(event)
	if boomer.state == "stop" then
		if event.phase == "began" then
			boomer.move()
		end	
	end
end

local function stop(event)
	if event.phase == "began" then
			boomer.stop()
	end
end

local throwButton = widget.newButton
{
   left = 150,
   top = 280,
   width = 40,                        --width of the image file(s)
   height = 20,                       --height of the image file(s)
   defaultFile = "bt_default.png",  --the "default" image file
   overFile = "bt_over.png",        --the "over" image file
   label = "T",
   onEvent = throw,
}
--[[
local stopButton = widget.newButton
{
   left = 100,
   top = 280,
   width = 40,                        --width of the image file(s)
   height = 20,                       --height of the image file(s)
   defaultFile = "bt_default.png",  --the "default" image file
   overFile = "bt_over.png",        --the "over" image file
   label = "S",
   onEvent = stop,
}

]]--
