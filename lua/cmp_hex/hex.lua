local M = {}
local curl = require("plenary.curl")

M.get_packages = function(request)
  local response = curl.request({
    url = "https://hex.pm/api/packages?search=" .. request .. "&sort=downloads",
    method = "get",
    accept = "application/json",
  })

  if response.status ~= 200 then
    error("Failed to search hex.pm, got a status: " .. response.status)
    return {}
  end

  return vim.fn.json_decode(response.body)
end

return M
