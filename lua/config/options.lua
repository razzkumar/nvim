-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
--

vim.opt.laststatus = 3
vim.g.snacks_animate = false

if vim.g.neovide then
  vim.g.neovide_transparency = 0.8
  vim.g.neovide_normal_opacity = 0.8
  vim.g.neovide_show_border = false
  -- vim.g.neovide_fullscreen = true
  -- vim.g.neovide_window_blurred = true
end
