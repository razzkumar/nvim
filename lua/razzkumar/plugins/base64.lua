return {
    "nvim-base64", -- Plugin name
    dir = "~/.config/nvim/lua/nvim-base64", -- Path to your plugin directory
    config = function()
        require("nvim-base64").setup() -- Setup your plugin
    end,
}
