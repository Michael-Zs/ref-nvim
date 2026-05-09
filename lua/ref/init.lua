---@brief Generates file/selection references like `@hello.c:20-30` and copies to clipboard.

local M = {}

---@class ref.Config
---@field prefix string Prefix for the reference (default: "@")
---@field path_style "filename"|"relative"|"absolute" Path style (default: "filename")
---@field register string Clipboard register (default: "+")

local config = {
  prefix = "@",
  path_style = "filename",
  register = "+",
}

---@param opts ref.Config|nil
function M.setup(opts)
  config = vim.tbl_extend("force", config, opts or {})
end

---Resolve the file path according to config.path_style
---@param buf number Buffer number
---@return string
local function resolve_path(buf)
  local filepath = vim.api.nvim_buf_get_name(buf)
  if filepath == "" then
    return "[No Name]"
  end
  if config.path_style == "absolute" then
    return filepath
  elseif config.path_style == "relative" then
    local cwd = vim.fn.getcwd()
    if filepath:sub(1, #cwd + 1) == cwd .. "/" then
      return filepath:sub(#cwd + 2)
    end
    return filepath
  else -- "filename"
    return vim.fn.fnamemodify(filepath, ":t")
  end
end

---Generate a reference string for the given range
---@param start_line number Start line (1-based)
---@param end_line number End line (1-based)
---@return string
function M.format_ref(start_line, end_line)
  local path = resolve_path(vim.api.nvim_get_current_buf())
  if start_line == end_line then
    return string.format("%s%s:%d", config.prefix, path, start_line)
  else
    return string.format("%s%s:%d-%d", config.prefix, path, start_line, end_line)
  end
end

---Copy reference to clipboard and notify
---@param start_line number
---@param end_line number
function M.yank_ref(start_line, end_line)
  local ref = M.format_ref(start_line, end_line)
  vim.fn.setreg(config.register, ref)
  -- Also yank to unnamed register for convenience
  vim.fn.setreg('"', ref)
  vim.notify(string.format("Copied: %s", ref), vim.log.levels.INFO)
end

return M
