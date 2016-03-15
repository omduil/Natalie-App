

width = 480
height = 320

function newImage( filename, x, y, scale )
  img = display.newImage( filename, x, y )
  img.xScale = scale
  img.yScale = scale
	return img
end


scrollSpeed = 0
scrollVel = -3
floor = 250





local foreground = newImage("foreground.png", 240, 295, .4)

local foreground1 = newImage("foreground.png", 806, 295, .4)


local background = newImage("background.png", 240, 119, .3)

local platform = newImage( "platform.png", 240, 200, .2)

local coin = newImage( "gold_1.png", 320, 190, .3)




local tree = {} 
x = 20
for i=1,8 do
	tree[i] = newImage("tree.png", x, 240, 0.2)
  x = x + 60 
end




local playerSheetOptions =
{
  width = 95,
  height = 130,
  numFrames = 42
}

local sequences_player = {
  {
    name = "noMotion",
    start = 20,
    count = 2,
    time = 800,
    loopCount = 0,
    loopDirection = "forward"
  },
  {
    name = "runRight",
    start = 1,
    count = 12,
    time = 800,
    loopCount = 0,
    loopDirection = "forward"
  },

}

-- array of platforms, test if player is between x coordinates of platforms, collecting coins with collision test




local sheet_player = graphics.newImageSheet( "player.png", playerSheetOptions )

local player = display.newSprite( sheet_player, sequences_player )





player.y = 250
player.x = 240
player.yScale = .5
player.xScale = .5


function updateFrame()
  dragon.x = dragon.x + 10
  if dragon.x > width + 200 then
    dragon.x = -50
  end
end

player:play()







local function backScroll(event)
  foreground.x = foreground.x + scrollSpeed
  foreground1.x = foreground1.x + scrollSpeed
  platform.x = platform.x + scrollSpeed
  coin.x = coin.x + scrollSpeed
  
  for i = 1,#tree do
    tree[i].x = tree[i].x + scrollSpeed
  end
  --easier with a group
  if foreground.x < -310 then
    foreground.x = 830
  end
  if foreground1.x < -310 then
    foreground1.x = 830
  end
  if foreground.x > 830 then
    foreground.x = -310
  end
  if foreground1.x > 830 then
    foreground1.x = -310
  end
end


function hitTest(x, y, x2, y2)
if math.sqrt((x - x2)^2 + (y - y2)^2) < 40 then
return true
else
return false
end
end

function coinCollision()
if hitTest(player.x, player.y, coin.x, coin.y) then
  coin.x = 600
  end
end
function jumpTest()
  if player.speed == 0 then
    return true
  else
    return false
  end
end



player.speed = 0


  



--Runtime:addEventListener("enterFrame", backScroll)
--Runtime:addEventListener("enterFrame", coinCollision)





function playerVelocity(event)
  print(event.phase)
  if (event.phase == "began") then
    if event.y >= display.contentCenterY then
    if (event.x >= display.contentCenterX) then
      scrollSpeed = scrollVel 
      player.xScale = .5
      player:setSequence( "runRight")
      player:play()
      
    end


    if (event.x <= display.contentCenterX) then
      scrollSpeed = -scrollVel
     player.xScale = -.5
      player:setSequence( "runRight")
      player:play()
    end
  end
  elseif (event.phase == "ended") then
    scrollSpeed = 0
    player:setSequence( "noMotion")
    player:play()
  end

end


function jump(event)
  if event.phase == "began" and event.y <= display.contentCenterY and jumpTest() then
 player.speed = -15
  end
end

function newFrame(event)

  player.y = player.y + player.speed
  
    if player.y > floor then
    player.speed = 0
  
 
  elseif (player.x > platform.x - 35 and player.x < platform.x + 35 and player.y < platform.y - 40) then
      
         
      floor = platform.y - 40
      player.speed = player.speed + 1
    
  else
     floor = 250
    player.speed = player.speed + 1
end
  end


Runtime:addEventListener("touch", playerVelocity)
Runtime:addEventListener("touch", jump)
Runtime:addEventListener("enterFrame", newFrame)
Runtime:addEventListener("enterFrame", backScroll)
Runtime:addEventListener("enterFrame", coinCollision)