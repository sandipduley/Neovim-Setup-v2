return {
    "mbbill/undotree",
    keys = {
        {
            "<leader>u",
            function()
                vim.cmd.UndotreeToggle()

                local function focus_and_resize_undotree()
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        local buf = vim.api.nvim_win_get_buf(win)
                        if vim.api.nvim_buf_get_option(buf, "filetype") == "undotree" then
                            vim.api.nvim_set_current_win(win)

                            -- Responsive sizing: 30% width, 60% height of current Neovim window
                            local width = math.floor(vim.o.columns * 0.3)
                            local height = math.floor(vim.o.lines * 0.6)
                            vim.api.nvim_win_set_width(win, width)
                            vim.api.nvim_win_set_height(win, height)

                            -- Disable line numbers for clean diff panel
                            vim.wo[win].number = false
                            vim.wo[win].relativenumber = false

                            -- Highlight current undo node
                            vim.cmd("hi! link UndoTreeCurrentLine CursorLine")
                            break
                        end
                    end
                end

                -- Focus and resize initially
                vim.defer_fn(focus_and_resize_undotree, 50)

                -- Create autocommand to resize UndoTree on VimResized
                vim.api.nvim_create_autocmd("VimResized", {
                    callback = function()
                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            if vim.api.nvim_buf_get_option(buf, "filetype") == "undotree" then
                                local width = math.floor(vim.o.columns * 0.5)
                                local height = math.floor(vim.o.lines * 0.6)
                                vim.api.nvim_win_set_width(win, width)
                                vim.api.nvim_win_set_height(win, height)
                            end
                        end
                    end,
                })
            end,
            desc = "Toggle UndoTree and focus",
        },
    },
}

