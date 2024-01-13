-- CONFIG
local URL = "https://raw.githubusercontent.com/Pwootage/cc-mstat/main/"

-- First, check if we're installed or not. We'll load settings (if any) and check.
-- If something went wrong, we'll re-try again later

local function download(url)
  print("Downloading mstat...")
  print("Getting file list...")
  local fileList = http.get(URL .. ".filelist")
  if fileList == nil then print("Failed to get file list!") exit(1) return end
  local fileListData = fileList.readAll()
  fileList.close()
  -- parse file list
  fileList = {}
  for s in str:gmatch("[^\r\n]+") do
    table.insert(fileList, s)
  end
  print("Found " .. #fileList .. " files to download.")

  -- Actually download files
  for i, file in ipairs(fileList) do
    print("Downloading " .. file .. "...")
    local fileData = http.get(URL .. file)
    if fileData == nil then print("Failed to download " .. file .. "!") exit(1) return end
    local fileDataStr = fileData.readAll()
    fileData.close()

    local fileHandle = fs.open("/mstat/" .. file, "w")
    fileHandle.write(fileDataStr)
    fileHandle.close()

    sleep(0.05)
  end
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
    boot()
  end
end

main()