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
local active_indices = {}
for i = 1, #words do
  active_indices[i] = i
end

local deleted_indices = {}

while true do
  print("\n--- Current Name Structure ---")
  for i, original_idx in ipairs(active_indices) do
    print(string.format("[%d] %s", i, words[original_idx]))
  end

  print("Continue (Y/n):")
  if io.read():upper() ~= "Y" then break end

  -- Delete Word
  print("Choose index to REMOVE:")
  local input = io.read()
  local choice = tonumber(input)

  if choice and choice >= 1 and choice <= #active_indices then
    local remove_original_idx = table.remove(active_indices, choice)
    table.insert(deleted_indices, remove_original_idx)
    print("Removed: " .. words[remove_original_idx])
  else
    print("invalid data")
  end
end

--Batch Processing
table.sort(deleted_indices, function(a, b) return a > b end)

for i = 1, #files do
  local current_name = files[i]
  local current_words = {}

  local base_name = current_name:gsub("%.wav$", "")
  for word in base_name:gmatch("([^%s]+)") do
    table.insert(current_words, word)
  end

  for _, idx in ipairs(deleted_indices) do
    if current_words[idx] then
      table.remove(current_words, idx)
    end
  end

  local result = table.concat(current_words, " ") .. ".wav"
  print(string.format("Result: %s", result))
  --os.rename(current_name, result)
end
