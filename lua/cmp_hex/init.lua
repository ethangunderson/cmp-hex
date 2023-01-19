local source = {}

local hex = require("cmp_hex/hex")

source.is_available = function()
  return vim.fn.expand("%:t") == "mix.exs"
end

source.new = function()
  local self = setmetatable({}, { __index = source })
  return self
end

source.get_trigger_characters = function()
  return {
    ":",
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
  }
end

source.complete = function(_, request, callback)
  local input = string.sub(request.context.cursor_before_line, request.offset)
  local prefix = string.sub(request.context.cursor_before_line, 1, request.offset - 1)

  if not vim.endswith(prefix, "{:") then
    return callback({ isIncomplete = true })
  end

  local packages = hex.get_packages(input)
  local results = {}

  for _, package in ipairs(packages) do
    local version = package["latest_stable_version"] or package["latest_version"]

    table.insert(results, {
      label = package["name"],
      kind = 1,
      sortText = package["name"],
      documentation = package["meta"]["description"],
      insertText = package["name"] .. ', "<~ ' .. tostring(version) .. '"',
    })
  end

  callback(results)
end

return source
