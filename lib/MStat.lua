MStat = {
  basalt = require('/mstat/lib/basalt'),
  debug = require('/mstat/lib/MStatDebug'),
  frames = {},
}
function MStat:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function MStat:init()
  self.mainFrame = self.basalt.createFrame()

  self.frames = {}

  self.homeFrame = self.mainFrame:addFrame("home")
      :setPosition(1, 2)
      :setSize("{parent.w}", "{parent.h - 1}")
      :hide()
  self.frames["home"] = self.homeFrame

  self.debugView = require("/mstat/ui/DebugFrame"):new(self.basalt, self.mainFrame)
  self.frames["debug"] = self.debugView.frame

  local s = self
  self.mainMenu = self.mainFrame:addMenubar()
      :setScrollable(true)
      :setSize("{parent.w}", 1)
      :onChange(function(self, event, item)
        mstat.debug:log("Switcing to frame", item.args[1])
        s:showFrame(item.args[1])
      end)
      :addItem("Home", nil, nil, "home")
      :addItem("Debug", nil, nil, "debug")
end

function MStat:showFrame(index)
  if self.frames[index] then
    for i, frame in pairs(self.frames) do
      frame:hide()
    end

    self.frames[index]:show()
  end
end

function MStat:run()
  -- self.mainMenu:selectItem(2)
  -- for i = 1, 150 do
  --   mstat.debug:log("Test", i)
  -- end
  self.basalt.autoUpdate()
end

local function init()
  print("Initializing mstat...")
  _G["mstat"] = MStat:new()
  mstat:init()
  mstat:run()
end

return { init = init }
