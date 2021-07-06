-- see if the file exists
function checkIfFileExists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local function char_count(str, ch)
  local n, p = 0
  while true do
    p = string.find(str, ch, p, true)
    if not p then break end
    n, p = n + 1, p + 1
  end
  return n
end

local function file_info(name, chunk_size)
  chunk_size = chunk_size or 4096
  local f, err, no = io.open(name, 'rb')
  if not f then return nil, err, no end
  local lines, size = 0, 0
  while true do
    local chunk = f:read(chunk_size)
    if not chunk then break end
    lines = lines + char_count(chunk, '\n')
    size = size + #chunk
  end
  f:close()
  return size, lines
end

function getAllLines(file)
  if not checkIfFileExists(file) then error("File doesnt exist !") end
  
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

function getNthLine(file, n)
  if not checkIfFileExists(file) then error("File doesnt exist !") end
  
  local f = io.open(file, "r")
  local count = 1

  for line in f:lines() do
    if count == n then
    f:close()
    return line
    end
  count = count + 1
  end

  f:close()
  error("Not enough lines in file!")
end

function getRandomLine(file)
  if not checkIfFileExists(file) then error("File doesnt exist !") end
  
  local size, lineCount = file_info(file, 32000)
  
  repeat
  repeat
  
  math.randomseed(os.time())
  local number = math.random(1, lineCount)
  
  line = getNthLine(file, number)
  until string.sub(line, 1, 4) == "FILE"
  
  splitLine = split(line, "\"")
  local fileExtension = string.match(splitLine[2], "%.(.*)")
  
  until reaper.IsMediaExtension(fileExtension, false )
  
  reaper.InsertMedia(splitLine[2], 0 )
   
end


local file = 'C:\\Users\\Alfred\\AppData\\Roaming\\REAPER\\MediaDB\\00.ReaperFileList'
getRandomLine(file)


