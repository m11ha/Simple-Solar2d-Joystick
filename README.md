# Simple-Solar2d-Joystick
A simple joystick for Solar2d projects
## Usage
+ Create a joystick instance:

      joystickClass=require 'Joystick'  
    
      joystick=joystickClass:create(options)
 + Put it on the screen
 
        joystick:show()
 +  Set the listener up

        joystick(joystick.eventName, listener)
        
 or
 
        joystick('Name of listener', listener)
## Options

| Name | Description | Default value |
| :------:| :-----: | ------ |
| innerRadius | Inner radius  | 20 |
| outerRadius | Outer radius  | 30 |
| x, y | Coords | x=innerRadius+outerRadius+20, y=display height-outer radius - inner radius |
| bcgrImagе | The background image | If not set, use  bcgrFeel and bcgrStroke |
| bulbImage | The foreground image | If not set, use  bulbrFeel and bulbStroke |
| bcgrFill, bcgrStroke, bulbFill, bulbStroke | Paint colors | Fill colors is black, stroke colors is white. The background fill color is transparent |
| eventName | Name of custom event | 'Control' |
