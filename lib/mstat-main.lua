MStat = {

}
function MStat:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self

  o:init()
  return o
end

function MStat:init()
  self.basalt = require('/mstat/lib/basalt')

  self.mainFrame = self.basalt.createFrame()

  self.frames = {}

  self.helloFrame = self.mainFrame:addFrame()
      :setPosition(1, 2)
      :setSize("{parent.w}", "{parent.h - 1}")
      :hide()
  table.insert(self.frames, self.helloFrame)

  self.debugFrame = self.mainFrame:addFrame()
      :setPosition(1, 2)
      :setSize("{parent.w}", "{parent.h - 1}")
      :hide()
  table.insert(self.frames, self.debugFrame)

  self.helloFrame:addLabel()
      :setText("Hello, world!")
      :setTextAlign("center")
      :setPosition(1, 1)
      :setSize("{parent.w}", 1)



  self.debugFrame:addLabel()
      :setText("Debug")
      :setTextAlign("center")
      :setPosition(1, 1)
      :setSize("{parent.w}", 1)

  local s = self
  self.mainFrame:addMenubar()
      :setScrollable(true)
      :setSize("{parent.w}", 1)
      :onChange(function(self, event, item)
        s:showFrame(item.args[1])
      end)
      :addItem("Main", nil, nil, 1)
      :addItem("Debug", nil, nil, 2)
end

function MStat:showFrame(index)
  if index and index > 0 and index <= #self.frames then
    for i, frame in ipairs(self.frames) do
      frame:hide()
    end

    self.frames[index]:show()
  end
end

function MStat:run()
  self.basalt.autoUpdate()
end

local function init()
  print("Initializing mstat...")

  local mstat = MStat:new()

  mstat:run()
end

return { init = init }
