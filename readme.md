# XYSLEW

XYSLEW is a small helper project for TouchOSC that gives you the ability to set a *slew* and *pull* parameter for a TouchOSC XY object.

https://github.com/neilbaldwin/XYSlew/blob/main/img/xyslew.mp4

*Slew* is used to slew the output from the XY object as you move the pointer around or if you touch/click and hold at a coordinate.

*Pull* is the TouchOSC parameter that sets the strength at which the control drifts back to it's zero/origin point.

## Challenge

The challenge here was to get both the Slew and the Pull feature working on the same XY object. It proved a little tricky at first because of the way the Pull works on the stock TouchOSC objects.

## Solution

My solution was two-fold. Firstly you need a *fake* or *ghost* XY object which will be hidden and is actually the one the user interracts with. The *real* XY object (the one that sends out controller values and messages) is visible but has the *interactive* property turned off. As the user moves the *fake* XY, it's values get sent to the *real* XY object and it's position is updated.

Then I have code both on the `onPointer()` function and also on the `onValueChanged()` function, each doing the same task (updating the target XY position based on the delta between the *fake* and the *real* XY object). The `onValueChanged()` function then needs to detect whether or not there is an active pointer (i.e the user is moving the object) because while the user moves the pointer we need to override the Pull value (to 0) to stop the pointer being automatically pulled - in essence battling against the user movement. During the Pull phase the function `onValueChanged()` gets constantly called by the system until the pointer returns to zero/origin position. That's why we need to stop it from *pulling* until we actually let go of the pointer. At that point, in the `onValueChanged` function, the Pull parameter is restored (according to the slider in my example) and this allows the Pull behaviour to operate as normal.

That's probably not the clearest description of what's going on but the code is well-commented so following it through should make more sense.

I've included the code separately but look at the example .TOSC file to see how to implement it. Apart from the main code, the two sliders also have a `onValueChanged()` function that uses the `:notify()` method on the XY object to send/set the Slew and Pull parameters.

Look at the top of the file `xyslew.lua` as there are a couple of constants to set the range/scale of both the slew and the pull.

### Usage

In your actual project you'll want to place the *ghost* XY on top of the real one and make the *ghost* one invisible. In the example I've separated them out so you can see what's going on.

Feel free to use and/or modify as you like.
