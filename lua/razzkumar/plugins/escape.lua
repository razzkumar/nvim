return {
    "max397574/better-escape.nvim",
    event = "BufReadPre",
    opts = {
        mapping = { "jk", "kj", "JK", "KJ", "jK", "kJ", "Jk", "Kj" },
        timeout = 120,
        clear_empty_lines = false,
        keys = "<Esc>",
    },
}
