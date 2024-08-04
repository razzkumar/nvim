local M = {}

-- Function to encode to Base64
function M.encode_base64()
    -- Get the start and end positions of the visual selection
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")

    -- Get the lines in the visual selection
    local lines = vim.fn.getline(start_pos[2], end_pos[2])

    -- Encode the selected text
    if #lines == 1 then
        -- Single line selection
        local col_start = start_pos[3]
        local col_end = end_pos[3]
        local line = lines[1]
        local selected_text = line:sub(col_start, col_end)
        local encoded = vim.fn.system('base64', selected_text):gsub('\n', '')
        lines[1] = line:sub(1, col_start - 1) .. encoded .. line:sub(col_end + 1)
    else
        -- Multi-line selection
        local col_start = start_pos[3]
        local col_end = end_pos[3]
        local first_line = lines[1]
        local last_line = lines[#lines]
        lines[1] = first_line:sub(1, col_start - 1) .. vim.fn.system('base64', first_line:sub(col_start)):gsub('\n', '')
        lines[#lines] = vim.fn.system('base64', last_line:sub(1, col_end)):gsub('\n', '') .. last_line:sub(col_end + 1)

        for i = 2, #lines - 1 do
            lines[i] = vim.fn.system('base64', lines[i]):gsub('\n', '')
        end
    end

    -- Replace the selected lines with the encoded lines
    vim.fn.setline(start_pos[2], lines)
end

-- Function to decode from Base64
function M.decode_base64()
    -- Get the start and end positions of the visual selection
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")

    -- Get the lines in the visual selection
    local lines = vim.fn.getline(start_pos[2], end_pos[2])

    -- Decode the selected text
    if #lines == 1 then
        -- Single line selection
        local col_start = start_pos[3]
        local col_end = end_pos[3]
        local line = lines[1]
        local selected_text = line:sub(col_start, col_end)
        local decoded = vim.fn.system('base64 --decode', selected_text):gsub('\n', '')
        lines[1] = line:sub(1, col_start - 1) .. decoded .. line:sub(col_end + 1)
    else
        -- Multi-line selection
        local col_start = start_pos[3]
        local col_end = end_pos[3]
        local first_line = lines[1]
        local last_line = lines[#lines]
        lines[1] = first_line:sub(1, col_start - 1) .. vim.fn.system('base64 --decode', first_line:sub(col_start)):gsub('\n', '')
        lines[#lines] = vim.fn.system('base64 --decode', last_line:sub(1, col_end)):gsub('\n', '') .. last_line:sub(col_end + 1)

        for i = 2, #lines - 1 do
            lines[i] = vim.fn.system('base64 --decode', lines[i]):gsub('\n', '')
        end
    end

    -- Replace the selected lines with the decoded lines
    vim.fn.setline(start_pos[2], lines)
end

-- Key mappings for visual mode
function M.setup()
    vim.api.nvim_set_keymap('v', '<leader>be', ':<C-U>lua require("nvim-base64").encode_base64()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', '<leader>ed', ':<C-U>lua require("nvim-base64").decode_base64()<CR>', { noremap = true, silent = true })
end

return M

