local M = {}

-- Helper to get the plugin directory
local function get_plugin_dir()
  local info = debug.getinfo(1, "S")
  -- source string starts with '@' for file path
  return info.source:sub(2):match("(.*/)")
end

-- Load and cache the system prompt template
local template
function M.load_template()
  if not template then
    local template_path = get_plugin_dir() .. "system_prompt.md"
    local f, err = io.open(template_path, "r")
    if not f then
      vim.notify("Failed to open system prompt template: " .. err, vim.log.levels.ERROR)
      return nil
    end
    template = f:read("*a")
    f:close()
  end
  return template
end

-- Interpolate the template with provided data
---@param data table A mapping of placeholder keys to replacement strings
---@return string
function M.get_system_prompt(data)
  local tpl = M.load_template()
  if not tpl then
    return ""
  end
  data = data or {}
  return tpl:gsub("%%(%w+)", function(key)
    return data[key] or ""
  end)
end

return M
