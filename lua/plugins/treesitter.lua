return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-context", config = true },
        { "windwp/nvim-ts-autotag", opts = {} },
    },
    config = function()
        local ts = require("nvim-treesitter")

        ts.setup({})

        -- Avoid parser installation checks on startup; they are expensive.
        -- Install/update parsers explicitly via :TSUpdate / :TSInstall.

        local group = vim.api.nvim_create_augroup("UserTreesitterStart", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = {
                "bash",
                "c",
                "cpp",
                "css",
                "dart",
                "dockerfile",
                "fish",
                "go",
                "graphql",
                "hcl",
                "helm",
                "html",
                "java",
                "javascript",
                "javascriptreact",
                "json",
                "lua",
                "make",
                "markdown",
                "prisma",
                "proto",
                "python",
                "query",
                "rust",
                "scss",
                "svelte",
                "sql",
                "terraform",
                "toml",
                "typescript",
                "typescriptreact",
                "vue",
                "yaml",
                "zig",
            },
            callback = function(event)
                local max_filesize = 200 * 1024 -- 200 KB
                local filename = vim.api.nvim_buf_get_name(event.buf)
                if filename == "" then
                    return
                end
                local ok, stats = pcall(vim.uv.fs_stat, filename)
                if ok and stats and stats.size > max_filesize then
                    return
                end
                pcall(vim.treesitter.start, event.buf)
            end,
        })
    end,
}
