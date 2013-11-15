t = {}

local options =
{
	frames =
   	{
		{ x = 0, y = 0, width = 31, height = 27 }, 
		{ x = 33, y = 0, width = 27, height = 31 }, 
		{ x = 62, y = 0, width = 31, height = 27 }, 
		{ x = 95, y = 0, width = 27, height = 31 }, 
   	},
}

local imageSheet = graphics.newImageSheet("boomer_spriteSheet.png", options)

local sequenceData =
{
   	{ name="stop", frames={1}},
   	{ name="move", frames={1,2,3,4}, time=500, loopCount=0 }, 
}	

local sprite = display.newSprite(imageSheet, sequenceData)

-- local attribute of the sprite 
local time			= 0				-- time counter --
local initial_pos 	= 240			-- starting position --
local range 		= 200			-- how far it would go --
local speed 		= 0.7			-- how fast the sprite moving --

-- initial condition of boomerang, execute with the require statement
-- those are public attribute that can get be changed outside the model
physics.addBody(sprite,"kinematic")
sprite.x = 200
sprite.y = 200
sprite.name = "boomer"
sprite.state = "stop" 

	-- LOCAL FUNCTION  --
local function moveEquation()
	time = time + speed 
	sprite.x = range*math.sin(t) + initial_pos
end	

	-- PUBLIC FUNCTION --

-- return the reference to the sprite --
function t.getSprite()
	return sprite
end

-- moving the sprite --
function t.moveSprite()
	sprite:setSequence("move")
	sprite:play()	
	Runtime:addEventListener( "enterFrame", moveEquation)
end

function t.stopSprite()
	sprite:setSequence("stop")
	sprite:play()
	Runtime:removeEventListener( "enterFrame", moveEquation)
end

return t

