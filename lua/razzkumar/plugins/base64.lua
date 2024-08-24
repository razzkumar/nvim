return {
    "nvim-base64", -- Plugin name
    dir = "~/.config/nvim/lua/nvim-base64", -- Path to your plugin directory

    keys = {
        {
            "<leader>be",
            function()
                require("nvim-base64").encode_base64()
            end,
            desc = "Encode selection to base64",
            mode = "v", -- Visual mode
        },
        {
            "<leader>ed",
            function()
                require("nvim-base64").decode_base64()
            end,
            desc = "Decode selection from base64",
            mode = "v", -- Visual mode
        },
    },
}
