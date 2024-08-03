vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

local lspconfig = require("lspconfig")

lspconfig.helm_ls.setup({
    settings = {
        ["helm-ls"] = {
            yamlls = {
                path = "yaml-language-server",
            },
        },
    },
})
