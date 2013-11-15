widget = require "widget"

local b = require "boomerang"
local boomer = b.getSprite()


local t,range,A = 0,200,200
--local range = 200
--local A = 200

local function flyBoomer(event)
	t = t + 0.08
	boomer.x = A*math.sin(t) + range
	if boomer.x > A+range-1 or boomer.x < -A+range+1 then		
		boomer.state = "closer"
		print(A)
	elseif 195 < boomer.x and boomer.x < 205 then
		A = A * 0.8
		boomer.state ="further"
	end
	
end


local function throw(event)
	if boomer.state == "stop" then
		boomer.state = "further"
		--t=0
		if event.phase == "began" then
			boomer:setSequence("fly")
			boomer:play()
			Runtime:addEventListener( "enterFrame", flyBoomer )
		end	
	end
end

local function stop(event)
	boomer.state = "stop"
	if event.phase == "began" then
		boomer:setSequence("stop")
		boomer:play()
		Runtime:removeEventListener( "enterFrame", flyBoomer )
	end	
	A = 200
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


