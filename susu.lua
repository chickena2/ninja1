local t = {}

local RUN_SPEED = 100

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
   	{ name="stand", frames={1}, time=500},
   	{ name="walk", frames={2,3,4,5}, time=1000, loopCount=0 }, 
   	{ name="jump", frames={6}, time=500},
   	{ name="throw", frames={7,8,9,1}, time=500, loopCount=1 }, 
   	
}	

local su = display.newSprite(imageSheet, sequenceData)
su.x = 100
su.y = 200
su.xScale = -1
su.state = "onGround"
su.forward = 0
physics.addBody(su,{bounce=0})
su.isFixedRotation = true

local b = require "boomer"
local boomer = b.getSprite()
--boomer:scale(0.5,0.5)
physics.addBody(boomer,"kinematic")
boomer.isSensor = true
boomer.name = "boomer"

local function stopBoomer()
	boomer.state = "stop"
	boomer.x = su.x+40
	boomer.y = su.y+5
	boomer:setLinearVelocity(0,0)
	boomer:setSequence("stop")
	boomer:play()
	--boomer.isVisible = false
end

widget = require "widget"

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

local function jump(event)
	if su.state == "onGround" then
		if event.phase == "began" then
			su.state = "offGround"
			su:setLinearVelocity(0,-200)
			su:setSequence("jump")
			su:play()
		end
	end	
	--if boomer.state == "fly" then
	--	transition.to(boomer, {time=100, x=su.x+40, y=su.y+5, onComplete=stopBoomer } )
	--end
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
	boomer.state = "flyBackWard"
	boomer:setLinearVelocity(-200,0 )
	timer.performWithDelay(1000, checkBoomerState)
end


local function flyBoomer()
	boomer.isVisible = true	
	boomer:setLinearVelocity(200,0)
	boomer:setSequence("fly")
	boomer:play()
	boomer.state = "flyForward"
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

su:addEventListener( "collision", character)





