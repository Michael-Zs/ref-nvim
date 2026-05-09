---@brief Plugin entry: creates the :Ref user command.

vim.api.nvim_create_user_command("Ref", function(opts)
  local ref = require("ref")
  ref.yank_ref(opts.line1, opts.line2)
end, {
  range = true,
  desc = "Generate file reference (e.g. @hello.c:20-30) and copy to clipboard",
})
