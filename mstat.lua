local args = table.pack(...)

-- CONFIG
local URL = "https://raw.githubusercontent.com/Pwootage/cc-mstat/main/"

-- First, check if we're installed or not. We'll load settings (if any) and check.
-- If something went wrong, we'll re-try again later

local function download(url, destination)
  if fs.exists(destination) then
    print("Do you want to replace the existing installation? (y/N)")
    local input = read()
    if input == "y" or input == "Y" then
      fs.delete(destination)
    else
      print("Aborting installation.")
      exit(1)
      return
    end
  end
  print("Downloading mstat to " .. destination .. "...")
  print("Getting file list...")
  local fileList = http.get(URL .. ".filelist")
  if fileList == nil then
    print("Failed to get file list!")
    exit(1)
    return
  end
  local fileListData = fileList.readAll()
  fileList.close()
  -- parse file list
  fileList = {}
  for s in fileListData:gmatch("[^\r\n]+") do
    table.insert(fileList, s)
  end
  print("Found " .. #fileList .. " files to download.")
  -- write filelist for future installs
  local fileHandle = fs.open(destination .. "/.filelist", "w")
  fileHandle.write(fileListData)
  fileHandle.close()

  -- Actually download files
  for i, file in ipairs(fileList) do
    print("Downloading " .. file .. "...")
    local fileData = http.get(URL .. file)
    if fileData == nil then
      print("Failed to download " .. file .. "!")
      exit(1)
      return
    end
    local fileDataStr = fileData.readAll()
    fileData.close()

    local fileHandle = fs.open(destination .. '/' .. file, "w")
    fileHandle.write(fileDataStr)
    fileHandle.close()

    sleep(0.05)
  end
end

local function localInstall(src, dest)
  if fs.exists(dest) then
    print("Do you want to replace the existing installation? (y/N)")
    local input = read()
    if input == "y" or input == "Y" then
      fs.delete(dest)
    else
      print("Aborting installation.")
      exit(1)
      return
    end
  end
  print("Installing mstat from " .. src .. " to " .. dest .. "...")
  local fileList = fs.open(src .. "/.filelist", "r")
  if fileList == nil then
    print("Failed to get file list!")
    exit(1)
    return
  end
  local fileListData = fileList.readAll()
  fileList.close()
  -- parse file list
  fileList = {}
  for s in fileListData:gmatch("[^\r\n]+") do
    table.insert(fileList, s)
  end
  print("Found " .. #fileList .. " files to install.")

  -- Actually install files
  for i, file in ipairs(fileList) do
    print("Installing " .. file .. "...")
    local fileData = fs.open(src .. '/' .. file, "r")
    local fileDataStr = fileData.readAll()
    fileData.close()

    local fileHandle = fs.open(dest .. '/' .. file, "w")
    fileHandle.write(fileDataStr)
    fileHandle.close()
  end
end

local function install(dest)
  local disks = { peripheral.find("drive") }
  local disk = nil
  for i, d in ipairs(disks) do
    if d.hasData() then
      local mountPath = d.getMountPath()
      if fs.exists(mountPath .. "/mstat") then
        disk = d
        break
      end
    end
  end

  if disk then
    print("Install from " .. (disk.getDiskLabel() or "<no label>") .. " mounted at " .. disk.getMountPath() .. "? (Y/n)")
    local input = read()
    if input == "y" or input == "Y" or input == "" then
      print("Installing from disk...")
      localInstall(disk.getMountPath() .. "/mstat", dest)
      return
    end
  end

  print("Install from github? (Y/n)")
  local input = read()
  if input == "y" or input == "Y" or input == "" then
    download(URL, dest)
    return
  end
end

local function createDisk()
  local disks = { peripheral.find("drive") }
  local disk = nil
  for i, d in ipairs(disks) do
    print(i .. ": " .. (d.getDiskLabel() or "<no label>") .. " mounted at /" .. d.getMountPath())
  end
  print("q: quit")
  print("Select a disk to install to:")
  local input = read()
  if input == "q" then
    return
  end
  disk = disks[tonumber(input)]
  if disk then
    print("Installing to " .. (disk.getDiskLabel() or "<no label>") .. " mounted at /" .. disk.getMountPath() .. "...")
    install(disk.getMountPath() .. "/mstat")
    print("Set label? (Y/n)")
    input = read()
    if input == "y" or input == "Y" or input == "" then
      disk.setDiskLabel("mstat")
      print("Set lable to mstat")
    end
  else
    print("Invalid disk!")
  end
end

local function boot()
  local mstat = require("/mstat/lib/MStat");
  mstat.init()
end

local function main()
  local installedLocally = fs.exists("/mstat/installed")

  if args[1] == "install" then
    install("/mstat")
  elseif args[1] == "createDisk" then
    createDisk()
  else
    boot()
  end
end

main()
