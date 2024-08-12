local x1 = 0
local y1 = 0
local x2 = 0
local y2 = 0
local deltax = 0
local deltay = 0
local slew = 1.0
local pull = 20

-- Constants to set behaviour and target object
local SLEW_SCALE = 200
local PULL_SCALE = 50
-- Set this variable to the name of the target XY object
local TARGET = self.parent.children.XY1

-- Called from SLEW and PULL sliders to set respective parameters
function onReceiveNotify(s, val)
  if (s == 'SLEW') then
    slew = 1.0 + (val * SLEW_SCALE)
  elseif (s == 'PULL') then
    pull = PULL_SCALE * val
    self:setValueProperty('x', ValueProperty.DEFAULT_PULL, pull)
    self:setValueProperty('y', ValueProperty.DEFAULT_PULL, pull)
  end
end

function updateXY(pullValue)
    -- Get reference to target XY object
    -- Set the 'Default Pull' value based on current interraction
    TARGET:setValueProperty('x', ValueProperty.DEFAULT_PULL, pullValue)
    TARGET:setValueProperty('y', ValueProperty.DEFAULT_PULL, pullValue)
    -- Get current X/Y position for 'ghost' and target XY object
    x1 = self.values.x
    y1 = self.values.y
    x2 = TARGET.values.x
    y2 = TARGET.values.y
    -- Calculate difference between 'ghost' and target for delta calculation
    deltax = (x1 - x2) / slew
    deltay = (y1 - y2) / slew
    x2 = x2 + deltax
    y2 = y2 + deltay
    -- Update the target XY object
    TARGET.values.x = x2
    TARGET.values.y = y2
end

-- onValueChanged() is called whenever the X/Y value of the ghost XY changes
-- The trick here is to override the Pull value of the target XY whenever user is
-- moving the 'ghost' XY. This stops the pull of the target XY intefering with the
-- X/Y values sent to it from the 'ghost'
-- Here we use the boolean value from .values.touch to determin if the user is intrracting
-- with the 'ghost' XY
function onValueChanged()
    if (self.values.touch) then
        -- If user moving 'ghost' XY, set target Pull to 0
        updateXY(0)
    else
        -- otherwise set target Pull to current Pull slider value
        updateXY(pull)
    end
end

-- The other trick is to always be updating the target X/Y for as long as there is pointer
-- activity in the 'ghost' XY. This prevents the update from stopping if the user is clicking/touching
-- the 'ghost' XY but it's X/Y values aren't changing i.e. user is holding on a position
function onPointer()
    updateXY(0)
end