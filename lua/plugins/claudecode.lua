return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal_cmd = "~/.local/bin/claude", -- Point to local installation
  },
  config = true,
}
