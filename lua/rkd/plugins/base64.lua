return {
    "iskolbin/lbase64",
    keys = {
        {
            "<leader>be",
            function()
                local base64 = require("base64")
                local selected_text = vim.fn.getline("'<", "'>")

                -- Encode the selected text to base64
                local encoded_text = base64.encode(selected_text)

                -- Replace the selected text with the encoded text
                vim.fn.setline("'<", { encoded_text })
            end,
            desc = "base64 encode",
        },
        {
            "<leader>bd",
            function()
                local base64 = require("base64")
                local selected_text = vim.fn.getline("'<", "'>")

                -- Decode the selected text from base64
                local decoded_text = base64.decode(selected_text)

                -- Replace the selected text with the decoded text
                vim.fn.setline("'<", { decoded_text })
            end,
            desc = "base64 decode",
        },
    },
}
