# ref.nvim

A tiny Neovim plugin that generates file/selection references like `@hello.c:20-30` and copies them to your clipboard.

## Install

**lazy.nvim:**
```lua
{ "Michael-Zs/ref-nvim" }
```

**vim-plug:**
```vim
Plug 'Michael-Zs/ref-nvim'
```

## Usage

| Command | Mode | Result |
|---------|------|--------|
| `:Ref` | Normal | `@hello.c:42` (current line) |
| `:'<,'>Ref` | Visual | `@hello.c:20-30` (selected range) |

## Keymaps (optional)

Add these to your config for quick access:

```lua
-- Normal mode: yank ref for current line
vim.keymap.set("n", "<leader>cr", "<cmd>Ref<cr>", { desc = "Copy file ref" })
-- Visual mode: yank ref for selection
vim.keymap.set("v", "<leader>cr", function()
  local start = vim.fn.line("v")
  local end_ = vim.fn.line(".")
  if start > end_ then start, end_ = end_, start end
  require("ref").yank_ref(start, end_)
end, { desc = "Copy file ref (visual)" })
```

## Configuration

```lua
require("ref").setup({
  prefix      = "@",        -- Prefix character
  path_style  = "filename", -- "filename" | "relative" | "absolute"
  register    = "+",        -- Clipboard register
})
```

### Path style examples

| `path_style` | Output |
|--------------|--------|
| `"filename"` (default) | `@hello.c:20-30` |
| `"relative"` | `@src/hello.c:20-30` |
| `"absolute"` | `@/home/user/src/hello.c:20-30` |
