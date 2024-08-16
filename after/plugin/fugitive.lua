vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gps", function ()
    vim.cmd("Git push")
end, {desc = "[G]it [P]u[S]h"})
vim.keymap.set("n", "<leader>gpl",function ()
    vim.cmd("Git pull")
end, {desc="[G]it [P]u[L]l"})

vim.keymap.set("n", "<leader>gco", ":Git checkout ", {desc = "[G]it [C]heck[O]ut"})
