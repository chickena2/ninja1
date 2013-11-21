local t = {}

local options =
{
	frames =
   	{
		{ x = 0, y = 0, width = 54, height = 65 },
		{ x = 56, y = 0, width = 54, height = 65  },
		{ x = 112, y = 0, width = 54, height = 65 },
		{ x = 168, y = 0, width = 54, height = 65 },
		{ x = 224, y = 0, width = 54, height = 65 },
		{ x = 280, y = 0, width = 54, height = 63 },
		{ x = 332, y = 0, width = 54, height = 59 },	-- throw 1 --
		{ x = 386, y = 4, width = 54, height = 61 },
		{ x = 440, y = 4, width = 56, height = 60 },	-- throw 3 --
   	},
}

local imageSheet = graphics.newImageSheet("su_spriteSheet.png", options)

local sequenceData =
{
   	{ name="stop", frames={1}, time=500},
   	{ name="walk", frames={2,3,4,5}, time=1000, loopCount=0 }, 
   	{ name="jump", frames={6}, time=500},
   	{ name="throw", frames={7,8,9,1}, time=500, loopCount=1 }, 
   	
}	

local sprite = display.newSprite(imageSheet, sequenceData)

-- Local Attribute --

local speed = 100
local boomer = require "boomerang"															-- su has a boomerang --
local hasBoomer = true
local onGround  = true
local ground = 203

-- Public attribute --


-- Initial condition --
physics.addBody(sprite, {bounce = 0})
sprite.x = 240
sprite.y = 200
sprite.name = "su"
sprite.xScale = -1
sprite.isFixedRotation = true

function sprite:collision(event)
	if event.phase == "began" then
		if event.other.name == "boomer" then
			sprite:removeEventListener( "collision", sprite)
			Runtime:removeEventListener( "enterFrame", isBack)
			boomer.stop()																	-- catch the boomerang --												
			hasBoomer = true
		end
	end
end

-- every frame check if the boomerang is back
local function isBack()
	if boomer.state == "closer" then														-- check if the boomerang is coming back --
		sprite:addEventListener( "collision", sprite)
		if boomer.getX() < sprite.x+20 then 
			
		end
	end
end

local function throw(event)	
	if hasBoomer == true then
	  	if event.phase == "began" then	
	  		boomer.setMoveEquationConst(sprite)  	  			
	  		boomer.move()	  																	-- throw the boomerang	  	
	  		Runtime:addEventListener( "enterFrame", isBack) 									-- every frame check if the boomerang is back --
	  		hasBoomer = false
	  	end
	end
end

-- listen for touch event
Runtime:addEventListener( "touch", throw)

local function stop(event)
	if event.phase == "began" then
		boomer.stop()
	end
end

local function isLanded()	
	print(sprite.y)													
	if sprite.y > ground then 
		Runtime:removeEventListener( "enterFrame", isLanded)
		sprite:setSequence("stop")
		sprite:play()																									
		onGround = true
	end
end

-- jump action --
local function jump(event)
	if onGround == true then
		if event.phase == "began" then
			onGround = false
			Runtime:addEventListener( "enterFrame", isLanded)
			sprite:setLinearVelocity(0,-200)
			sprite:setSequence("jump")
			sprite:play()
		end
	end	
end

local widget 	= require "widget"

local jumpButton = widget.newButton
{
   left = 100,
   top = 280,
   width = 40,                        --width of the image file(s)
   height = 20,                       --height of the image file(s)
   defaultFile = "bt_default.png",  --the "default" image file
   overFile = "bt_over.png",        --the "over" image file
   label = "J",
   onEvent = jump,
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



--[[

local function moveRight(event)
	if su.state == "onGround" then
		if event.phase == "began" then	
			su.xScale = -1	
			su:setLinearVelocity(RUN_SPEED,0)
			su:setSequence("walk")
			su:play()	
		elseif event.phase == "ended" then
			su:setLinearVelocity(0,0)
			su:setSequence("stand")
			su:play()
			if boomer.state == "stop" then
				stopBoomer()
			end
		end
	else
		if su.forward == 0 then
			local vx, vy = su:getLinearVelocity()
			su:setLinearVelocity(RUN_SPEED,vy)
			su.forward = 1
		end
	end
end

local function moveLeft(event)
	if event.phase == "began" then
		su.xScale = 1
		su:setLinearVelocity(-RUN_SPEED,0)
		su:setSequence("walk")
		su:play()
	elseif event.phase == "ended" then
		su:setLinearVelocity(0,0)
		su:setSequence("stand")
		su:play()
	end
end




stopBoomer()

local function flyFast()
	if boomer.state == "fly" then
		transition.to(boomer, {time=100, x=su.x+40, y=su.y+5, onComplete=flyFast } )
	else 
		stopBoomer()
	end
end

local v = {}

local function flyDirection()
	v.x = boomer.x - su.x
	v.y = boomer.y - su.y 
end

local function checkBoomerState()
	if boomer.x < su.x then
		print("su jump")
	else
		print("su move back")
	end
end

local function flyBack()
	--transition.to(boomer, {time=1000, x=su.x, y=su.y, onComplete=flyFast } )
	boomer:setLinearVelocity(-200,0 )
	timer.performWithDelay(1000, checkBoomerState)
end


local function flyBoomer()
	boomer.isVisible = true	
	boomer:setLinearVelocity(200,0)
	boomer:setSequence("fly")
	boomer:play()
	boomer.state = "fly"
	timer.performWithDelay(1000, flyBack)
end

local function throw(event)
	if event.phase == "began" then
		if boomer.state == "stop" then
			su:setSequence("throw")
			su:play()
			boomer.x = su.x+40
			boomer.y = su.y+5
			flyBoomer()
		end
	end	
end

local rightButton = widget.newButton
{
   left = 50,
   top = 280,
   width = 40,                        --width of the image file(s)
   height = 20,                       --height of the image file(s)
   defaultFile = "bt_default.png",  --the "default" image file
   overFile = "bt_over.png",        --the "over" image file
   label = "",
   onEvent = moveRight,
}

local leftButton = widget.newButton
{
   left = 5,
   top = 280,
   width = 40,                        --width of the image file(s)
   height = 20,                       --height of the image file(s)
   defaultFile = "bt_default.png",  --the "default" image file
   overFile = "bt_over.png",        --the "over" image file
   label = "",
   onEvent = moveLeft,
}



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



function su:collision(event)
	if ( event.phase == "began" ) then
		if event.other.name == "ground1" then
			su.state = "onGround"
			su.forward = 0
			su:setSequence("stand")
			su:play()
			su:setLinearVelocity(0,0)		
		end
	elseif ( event.phase == "ended" ) then		
		if event.other.name == "boomer" then
			if boomer.state == "fly" then
				boomer:setLinearVelocity(0,0)
				--stopBoomer()
			end	
		end
	end
end


]]--
return t



