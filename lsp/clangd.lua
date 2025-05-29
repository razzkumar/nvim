-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function get_clangd_client(bufnr)
    for _, client in ipairs(vim.lsp.get_active_clients()) do
        if client.name == "clangd" and vim.lsp.buf_is_attached(bufnr, client.id) then
            return client
        end
    end
end

local function switch_source_header(bufnr)
    local method_name = "textDocument/switchSourceHeader"
    local client = get_clangd_client(bufnr)
    if not client then
        return vim.notify(
            ("method %s is not supported by any servers active on the current buffer"):format(method_name),
            vim.log.levels.ERROR
        )
    end
    local params = vim.lsp.util.make_text_document_params(bufnr)
    client.request(method_name, params, function(err, result)
        if err then
            vim.notify(tostring(err), vim.log.levels.ERROR)
            return
        end
        if not result then
            vim.notify("corresponding file cannot be determined", vim.log.levels.WARN)
            return
        end
        vim.cmd.edit(vim.uri_to_fname(result))
    end, bufnr)
end

local function symbol_info()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = get_clangd_client(bufnr)
    if not client or not client.supports_method("textDocument/symbolInfo") then
        return vim.notify("Clangd client not found or doesn't support symbolInfo", vim.log.levels.ERROR)
    end
    local params = vim.lsp.util.make_position_params()
    client.request("textDocument/symbolInfo", params, function(err, res)
        if err or not res or vim.tbl_isempty(res) then
            vim.notify("No symbol info available", vim.log.levels.WARN)
            return
        end
        local container = string.format("container: %s", res[1].containerName or "")
        local name = string.format("name: %s", res[1].name or "")
        vim.lsp.util.open_floating_preview({ name, container }, "", {
            height = 2,
            width = math.max(string.len(name), string.len(container)),
            focusable = false,
            border = "single",
            title = "Symbol Info",
        })
    end, bufnr)
end

---@type vim.lsp.Config
return {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    root_markers = {
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
        ".git",
    },
    capabilities = {
        textDocument = {
            completion = {
                editsNearCursor = true,
            },
        },
        offsetEncoding = { "utf-8", "utf-16" },
    },
    on_attach = function(_, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeader", function()
            switch_source_header(bufnr)
        end, { desc = "Switch between source/header" })

        vim.api.nvim_buf_create_user_command(bufnr, "LspClangdShowSymbolInfo", function()
            symbol_info()
        end, { desc = "Show symbol info" })
    end,
}
