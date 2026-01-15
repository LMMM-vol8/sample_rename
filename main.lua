--Check OS
local is_windows = package.config.sub(1, 1) == "\\"
local list_cmd = is_windows and "dir /b" or "ls"

--Read File
local handle = io.popen(list_cmd)
if not handle then
  print("File Not Exist")
  return
end

-- File list
local files = {}
for filename in handle:lines() do
  if filename:match("%.wav$") then
    table.insert(files, filename)
  end
end
handle:close()

if #files == 0 then return end

-- Text Edit
local words = {}
for word in files[1]:gmatch("([^%s%.]+)") do
  if word == nil or word == "" then
    error("Error: Contains invalid words")
  end
  table.insert(words, word)
end
table.remove(words, #words)

-- display state
local index_list = {}
while true do
  for i = 1, #words do
    print(string.format("Index %d: %s", i, words[i]))
  end
  print("Continue (Y/n):")
  if io.read():upper() ~= "Y" then
    print("Loop End")
    break;
  end
  -- Delete Word
  print("Choose delete word index :")
  local input = io.read()
  local index = tonumber(input)
  if index or 0 < index or index > #words then
    print("Input number is invalid data")
  end
  table.remove(words, index)
  table.insert(index_list, index)
end


for i = 1, #files do
  local current_name = files[i]
  local words = {}

  local base_name = current_name:gsub("%.wav$", "")
  for word in base_name:gmatch("([^%s]+)") do
    table.insert(words, word)
  end

  table.sort(index_list, function(a, b) return a > b end)
  for _, idx in ipairs(index_list) do
    if words[idx] then
      table.remove(words, idx)
    end
  end

  local new_name = table.concat(words, " ") .. ".wav"
  print(string.format("Rename: %s -> %s", current_name, new_name))
  --os.rename(current_name, new_name)
end
