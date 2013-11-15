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
   	{ name="fly", frames={1,2,3,4}, time=500, loopCount=0 }, 
}	

local sprite = display.newSprite(imageSheet, sequenceData)

function t.getSprite()
	return sprite
end

return t

