-- First, check if we're installed or not. We'll load settings (if any) and check.
-- If something went wrong, we'll re-try again later

local function download(url)
  print("Downloading mstat...")
  -- println("Looking up tree on github")
end

local function boot()
  local mstat = require("/mstat/lib/mstat-main");
  mstat.init()
end

local function main()
  if fs.exists("/mstat/installed") then
    boot()
  else
    download()
  end
end

main()