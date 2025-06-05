return {
    "saghen/blink.cmp",
    event = "LspAttach",
    version = "1.*",
    build = "cargo build --release",

    dependencies = {
        "rafamadriz/friendly-snippets",
    },

    opts = {
        cmdline = { enabled = false },
        fuzzy = {
            implementation = "prefer_rust",
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        signature = {
            enabled = true,
            window = { border = "rounded" },
        },
        completion = {
            documentation = {
                auto_show = true,
                window = { border = "rounded" },
            },
            menu = {
                border = "rounded",
            },
        },

        appearance = {
            nerd_font_variant = "normal",
            kind_icons = require("utils.kinds").icons,
        },

        keymap = {
            preset = "enter",
            ["<Tab>"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<C-y>"] = { "select_and_accept" },
            ["<C-e>"] = { "cancel", "fallback" },
            ["<CR>"] = {
                function()
                    local cmp_popup = require("blink.cmp").popup
                    if cmp_popup and cmp_popup:is_visible() then
                        cmp_popup:cancel()
                    else
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
                    end
                end,
            },
        },
    },
}
