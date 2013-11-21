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

-- Local attribute of the sprite --

local time				= 0				-- time counter --
local initial_x 		= 240			-- starting position --
local range 			= 200			-- how far it would go --
local speed 			= 0.085			-- how fast the sprite moving --
local range_decrease 	= 0.85

-- initial condition of boomerang, execute with the require statement
-- those are public attribute that can get be changed outside the model
physics.addBody(sprite,"kinematic")
sprite.x = 240
sprite.y = 200
sprite.name = "boomer"
sprite.isSensor = true
sprite.isVisible = false

-- Public attribute --
t.state = "stop" 

	-- LOCAL FUNCTION  --
	
-- change state of the sprite according to position
local function changeState()
	-- check if the boomerang at max right, max left, or in the middle 
	if (sprite.x > range + initial_x - 1) or (sprite.x < -range + initial_x + 1) then		
		t.state = "closer"
	elseif initial_x - 15 < sprite.x and sprite.x < initial_x + 15 then
	if sprite.x < initial_x then
			range = range * range_decrease
		end
		t.state ="further"
	end
end

-- moving equation of the sprite, call every frame --
local function moveEquation()
	time = time + speed 
	sprite.x = range*math.sin(time) + initial_x
	changeState()
end	

	-- PUBLIC FUNCTION --

-- moving the sprite --
function t.move()
	sprite.isVisible = true
	sprite:setSequence("move")
	sprite:play()	
	Runtime:addEventListener( "enterFrame", moveEquation)
end

-- stop the sprite --
function t.stop()
	sprite.isVisible = false
	sprite:setSequence("stop")
	sprite:play()
	Runtime:removeEventListener( "enterFrame", moveEquation)
	t.state = "stop"
	time = 0
	range = 200
end

-- get the x postion fo the sprite --
function t.getX()
	return sprite.x
end

-- return the reference to the sprite --
function t.getSprite()
	return sprite
end

-- change starting point of the sprite --
function t.setMoveEquationConst(s)
	--initial_x = s.x
	sprite.y = s.y
end

return t

