require("lspconfig")["volar"].setup({
    on_attach = require("rkd.plugins.lsp.settings").on_attach,
    capabilities = require("rkd.plugins.lsp.settings").capabilities,
    filetypes = {
        "typescript",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "json",
    },
    settings = {
        volar = {
            codeLens = {
                references = true,
                pugTools = true,
                scriptSetupTools = true,
            },
        },
    },
})
