print("Hello, world!")

function init()
  print("Initializing mstat...")

  local settings = fs.open("/mstat/settings.json", "r")
  local settingsData = settings.readAll()
  settings.close()
  local settingsTable = textutils.unserializeJSON(settingsData)
end
