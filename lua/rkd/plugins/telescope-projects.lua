return {
    "ahmedkhalf/project.nvim",
    config = function()
        require("project_nvim").setup({
            sync_root_with_cwd = true,
            detection_methods = { "pattern" },

            patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "pom.xml" },
            respect_buf_cwd = true,
            update_focused_file = {
                enable = true,
                update_root = true,
            },
        })
        require("telescope").load_extension("projects")
        vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "Open project" })
    end,
}
