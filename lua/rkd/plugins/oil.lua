return {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
        { "<leader>fe", "<cmd>Oil --float<cr>", desc = "Open float directory" },
    },
    opts = {
        delete_to_trash = true,
        default_file_explorer = false,
        skip_confirm_for_simple_edits = true,
        view_options = { show_hidden = true },
        keymaps = {
            ["<C-v>"] = "actions.select_vsplit",
            ["<C-x>"] = "actions.select_split",
            ["<A-w>"] = "actions.preview",
            ["<A-d>"] = "actions.close",
        },
        float = {
            -- Padding around the floating window
            padding = 5,
            max_width = 50,
            max_height = 0,
            border = "rounded",
            win_options = {
                winblend = 0,
            },
            override = function(conf)
                return conf
            end,
        },
    },
}
