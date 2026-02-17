---[[ LSP configuration

local lsp_files = {}
local lsp_dir = vim.fn.stdpath("config") .. "/lsp/"
local save_group = vim.api.nvim_create_augroup("UserLspSaveActions", { clear = true })
local missing_servers = {}

local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if vim.fn.isdirectory(mason_bin) == 1 and not vim.env.PATH:find(mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

for _, file in ipairs(vim.fn.globpath(lsp_dir, "*.lua", false, true)) do
    local f = io.open(file, "r")
    local first_line = f and f:read("*l") or ""
    if f then
        f:close()
    end
    if not first_line:match("^%-%- disable") then
        local name = vim.fn.fnamemodify(file, ":t:r")
        local ok, cfg = pcall(dofile, file)
        local cmd = ok and type(cfg) == "table" and cfg.cmd or nil
        local bin = type(cmd) == "table" and cmd[1] or nil

        if type(bin) == "string" and vim.fn.executable(bin) == 0 then
            table.insert(missing_servers, string.format("%s (%s)", name, bin))
        else
            table.insert(lsp_files, name)
        end
    end
end

vim.lsp.enable(lsp_files)

if #missing_servers > 0 then
    vim.schedule(function()
        vim.notify("Skipped LSP configs (missing binaries): " .. table.concat(missing_servers, ", "), vim.log.levels.WARN)
    end)
end

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        vim.opt_local.formatoptions:remove({ "r", "o" })
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank({
            higroup = "IncSearch",
            timeout = 200,
        })
    end,
})

vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.ERROR] = " ",
        },
    },
})

local function format_with_none_ls(bufnr)
    local has_none_ls = #vim.lsp.get_clients({ bufnr = bufnr, name = "null-ls" }) > 0
    if not has_none_ls then
        return
    end

    vim.lsp.buf.format({
        bufnr = bufnr,
        async = false,
        timeout_ms = 2000,
        filter = function(client)
            return client.name == "null-ls"
        end,
    })
end

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        if client.name ~= "null-ls" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end

        vim.api.nvim_clear_autocmds({ group = save_group, buffer = args.buf })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = save_group,
            buffer = args.buf,
            desc = "Format with none-ls",
            callback = function()
                format_with_none_ls(args.buf)
            end,
        })

        local nmap = function(keys, func, desc)
            if desc then
                desc = "LSP: " .. desc
            end
            vim.keymap.set("n", keys, func, { buffer = args.buf, noremap = true, silent = true, desc = desc })
        end

        nmap("K", vim.lsp.buf.hover, "Open hover")
        nmap("<leader>r", vim.lsp.buf.rename, "Rename")
        nmap("<leader>dr", vim.lsp.buf.references, "References")
        nmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
        nmap("<leader>df", vim.lsp.buf.definition, "Goto definition")
        nmap("<leader>ds", "<cmd>vs | lua vim.lsp.buf.definition()<cr>", "Goto definition (v-split)")
        nmap("<leader>dh", "<cmd>sp | lua vim.lsp.buf.definition()<cr>", "Goto definition (h-split)")

        nmap("dn", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, "Goto next diagnostic")
        nmap("dN", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, "Goto prev diagnostic")
        nmap("<leader>q", vim.diagnostic.setloclist, "Open diagnostics list")
        nmap("<leader>e", vim.diagnostic.open_float, "Open diagnostic float")

        vim.keymap.set("i", "<M-t>", vim.lsp.buf.signature_help, { buffer = args.buf })

        nmap("<leader>lh", function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = args.buf })
        end, "Toggle inlay hints")

        vim.api.nvim_buf_create_user_command(args.buf, "Fmt", function()
            format_with_none_ls(args.buf)
        end, { desc = "Format current buffer with none-ls" })

        require("illuminate").configure({
            delay = 200,
            large_file_cutoff = 2000,
            large_file_overrides = {
                providers = { "lsp" },
            },
        })
        require("illuminate").on_attach(client)
    end,
})
