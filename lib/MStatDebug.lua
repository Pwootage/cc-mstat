MStatDebug = {
  log = function (self, ...)
    local args = { ... }
    local str = ""
    for i, arg in pairs(args) do
      str = str .. tostring(arg) .. " "
    end
    table.insert(self.debugLogs, str)
    if #self.debugLogs > 100 then
      table.remove(self.debugLogs, 1)
    end
    for i, func in pairs(self._onUpdate) do
      func(self)
    end
  end,

  debugLogs = {},
  onUpdate = function (self, func)
    table.insert(self._onUpdate, func)
  end,
  _onUpdate = {},
}

return MStatDebug