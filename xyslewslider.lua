
-- Add this script to your SLEW and PULL sliders
-- IMPORTANT: you need to name the sliders "SLEW" and "PULL" as this name is
-- used to send the values to the correct variables in the main script
function onValueChanged(key)
    local name = self.name
    self.parent.children.XY2:notify(name, self.values.x)
end