local joystick={}



function joystick:create(options)
	local obj={}
	setmetatable( obj, self )
	self.__index=self



	obj.outerRadius=options.outerRadius or 30 
	obj.innerRadius= options.innerRadius or 20
	obj.maxDiistance=obj.outerRadius*3
	obj.x= options.x or obj.outerRadius+obj.innerRadius+20
	obj.y= options.y or display.contentHeight- obj.outerRadius+obj.innerRadius
	obj.bulbImage=options.bulbImage
	obj.bcgrImage=options.bcgrImobj
	obj.isActive=false
	obj.isAvailable=true
	obj.focusable=options.focusable or true
	obj.bcgrFeel=options.bcgrFeel or {}
	obj.bcgrStroke=options.bcgrStroke or {}
	obj.bulbFeel=options.bulbFeel or {}
	obj.bulbStroke=options.bulbStroke or {}
	obj.eventName=options.eventName or 'Control'

	setmetatable( obj.bcgrFeel,obj.bcgrFeel )
	setmetatable( obj.bcgrStroke,obj.bcgrStroke )
	setmetatable( obj.bulbFeel,obj.bulbFeel)
	setmetatable( obj.bulbStroke,obj.bulbStroke)
	
	local bcgrFeelProto= {red=0,green=0,blue=0,alpha=0} 
	local bcgrStrokeProto= {red=1,green=1,blue=1,alpha=0.5,width=2} 
	local bulbFeelProto={red=0,green=0,blue=0,alpha=1} 
	local bulbStrokeProto= {red=1,green=1,blue=1,alpha=0.5, width=2}

	obj.bcgrFeel.__index=bcgrFeelProto
	obj.bcgrStroke.__index=bcgrStrokeProto
	obj.bulbFeel.__index=bulbFeelProto
	obj.bulbStroke.__index=bulbStrokeProto

	return obj
end

local function distance(obj1,obj2)
	local dy=obj1.y-obj2.y
	local dx=obj1.x-obj2.x
	return math.sqrt( dy*dy+dx*dx )
end

function joystick:touch(event)
	local target=event.target
	local angle=math.atan2( event.y-self.y, event.x-self.x )

	local phase=event.phase

	if(phase=='began') then
		if self.focusable then display.getCurrentStage( ):setFocus( target ) end
		target.isFocus=true
	elseif(target.isFocus==true) then
		if(phase=='moved' and  distance(self, event)< self.maxDiistance) then
			self.isActive=true
			
			local ex,ey= event.x, event.y
			if(distance(self, event)>self.outerRadius) then
				
				local minmaxX=math.cos(angle)*self.outerRadius+self.x
				local minmaxY=math.sin(angle)*self.outerRadius+self.y
				if self.x>ex then
					ex=math.max(minmaxX,ex)
				else
					ex=math.min(minmaxX,ex)
				end

				if self.y>ey then 
					ey=math.max(minmaxY,ey)
				else
					ey=math.min(minmaxY,ey)
				end
			end

			self.bulb.x=ex
			self.bulb.y=ey

			target:dispatchEvent{ name=self.eventName, angle=angle, modul=distance(target,self)/self.outerRadius}
			
		else
			self.isActive=false
			self.isAvailable=false
			transition.to( self.bulb, {
				time=300, x=self.x, y=self.y, transition=easing.outBounce,
				onComplete=function()
					self.isAvailable=true
					angle=0
					
					target:dispatchEvent({ name=self.eventName, angle=angle, modul=distance(target,self)/self.outerRadius})
				end
				} )
			display.getCurrentStage( ):setFocus( nil )
			target.isFocus=false
			self.isActive=false
		end
	end
	return true
end



function joystick:show()
	local outer
	if(self.bcgrImage == nil) then
		outer=display.newCircle(  self.x, self.y, self.outerRadius )
		
		outer:setFillColor(self.bcgrFeel.red,self.bcgrFeel.green,
			self.bcgrFeel.blue,self.bcgrFeel.alpha)
		outer:setStrokeColor( self.bcgrStroke.red, self.bcgrStroke.green,
			self.bcgrStroke.blue,self.bcgrStroke.alpha )
		outer.strokeWidth=self.bcgrStroke.width
	else
		outer=display.newImageRect( self.bcgrImage, self.outerRadius*2, self.outerRadius*2 )
		outer.x, outer.y=self.x, self.y
	end
	if(self.bulbImage == nil) then
		self.bulb=display.newCircle(  self.x, self.y, self.innerRadius )
		
		self.bulb:setFillColor(self.bulbFeel.red,self.bulbFeel.green,
			self.bulbFeel.blue,self.bulbFeel.alpha)
		self.bulb:setStrokeColor( self.bulbStroke.red, self.bulbStroke.green,
			self.bulbStroke.blue,self.bulbStroke.alpha )
		self.bulb.strokeWidth=self.bulbStroke.width
	else
		self.bulb=display.newImageRect( self.bulbImage, self.innerRadius*2, self.innerRadius*2 )
		self.bulb.x, self.bulb.y=self.x, self.y
	end

	self.bulb:addEventListener( 'touch', self )

end



return joystick