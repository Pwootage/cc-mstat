DebugView = {
  init = function(self)
    local view = self
    self.frame = self.parent:addFrame("debug")
        :setPosition(1, 2)
        :setSize("{parent.w - 1}", "{parent.h - 2}")
        :setBorder(colors.gray)
        :setBackground(colors.black)
        :setForeground(colors.white)
        :setTheme({ FrameBG = colors.black, FrameFG = colors.white })

    local title = self.frame:addLabel()
        :setText(" Debug Logs ")
        :setBackground(colors.gray)
        :setForeground(colors.black)
        :setPosition(1, 1)

    self.scrollableFrame = self.frame:addFrame()
        :setPosition(2, 2)
        :setSize("{parent.w - 3}", "{parent.h - 3}")
        -- :onScroll(function(self, event, dir)
        --   local _, offset = self:getOffset()
        --   offset = offset + dir
        --   title:setText(" Debug Logs " .. offset)
        --   view.scrollbar:setIndex(offset + dir)
        --   view.scrollbar:setScrollAmount(view.scrollbar:getScrollAmount())
        -- end)

    self.scrollbar = self.frame:addScrollbar()
        :setPosition("{parent.w - 1}", 2)
        :setSize(1, "{parent.h - 3}")
        :setSymbol(" ", colors.white, colors.lightGray)
        :setBackground(colors.gray, "\x95", colors.black)
        :onChange(function(self)
          view.scrollableFrame:setOffset(0, self:getIndex() - 1)
          title:setText(" Debug Logs " .. (self:getIndex()-1))
        end)


    self.logLabels = {}

    mstat.debug:onUpdate(function()
      view:update()
    end)
  end,
  update = function(self)
    local logCount = #mstat.debug.debugLogs
    if logCount > #self.logLabels then
      for i = #self.logLabels + 1, logCount do
        local label = self.scrollableFrame:addLabel()
            :setPosition(1, i)
            :setSize("{parent.w - 2}", 1)
            :setForeground(colors.white)
            :setBackground(colors.black)
        self.logLabels[i] = label
      end
    end
    for i, label in pairs(self.logLabels) do
      label:setText(mstat.debug.debugLogs[i])
    end
    local h = self.scrollableFrame:getHeight()
    local pos = math.max(logCount - h, 0)

    self.scrollbar:setScrollAmount(pos + 2)
    self.scrollableFrame:setOffset(0, pos)
  end
}
function DebugView:new(basalt, parent)
  local object = {}
  setmetatable(object, self)
  self.__index = self

  object.basalt = basalt
  object.parent = parent
  object:init()
  return object
end

return DebugView
