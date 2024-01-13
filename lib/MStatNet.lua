MStatNet = {

}
function MStatNet:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self

  o:init()
  return o
end

function MStatNet:init()
  local modems = { peripheral.find("modem") }

end




return { MStatNet = MStatNet }