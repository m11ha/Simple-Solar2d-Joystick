-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
system.activate( 'multitouch' )
local joystickClass=require 'joystick'
joystick=joystickClass:create{bulbImage='bulb.png',eventName='myJoystick'}
joystick2=joystickClass:create{eventName='mySecondJoystick',x=display.contentWidth-80,bulbStroke={red=1,green=0,blue=0,alpha=1}}


local txt1= display.newText{ text='angle', x=display.contentCenterX,y= display.contentCenterY,
font=native.systemFont,fontSize=24 }
local txt2= display.newText{ text='module', x=display.contentCenterX,y= display.contentCenterY+32,
font=native.systemFont,fontSize=24 }


joystick:show()
joystick2:show()
joystick.bulb:addEventListener( joystick.eventName, function ( event )
	txt1.text=event.angle
end )
joystick2.bulb:addEventListener( joystick2.eventName, function ( event )
	txt2.text=event.modul
end )

