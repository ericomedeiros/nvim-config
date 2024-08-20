vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor same place when grabbing line bellow
vim.keymap.set("n", "J", "mzJ`z")

-- Keep cursor in the middle of screen when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- n= next result; zz = redraw at cursor (will centre screen);
-- zv = open enough folds to display the cursor position
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
-- when pasting do not loose to deleted
vim.keymap.set("x", "<leader>p", [["_dP]], {desc = 'Paste without loosing'})

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cptev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>cw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

vim.keymap.set("n", "<leader>log", function()
  local line = vim.api.nvim_win_get_cursor(0)
  print(line);
  local lineV = vim.api.nvim_get_current_line()
  vim.api.nvim_buf_set_lines(0, line[1]-1, line[1], true, {"console.log(\""..lineV.."\", "..lineV..");"})
end)

vim.keymap.set({"n","v"}, "<leader>aar", function()
  local mode = vim.api.nvim_get_mode() -- n = normal,v - visual
  if(mode["mode"] == "n") then
    vim.api.nvim_feedkeys("viw", "xt", false)
  end
  local position = vim.fn.getpos("v")
  local colEnd = vim.fn.col(".")
  local key = vim.fn.input("Around with what? ")
  local txt = vim.api.nvim_buf_get_text(position[1], position[2]-1, position[3]-1, position[2]-1, colEnd, {})
  local cases = {
    ['{'] = function ()
      vim.api.nvim_buf_set_text(position[1], position[2]-1, position[3]-1, position[2]-1, colEnd, {"{"..txt[1].."}"})
    end,
    ['('] = function ()
      vim.api.nvim_buf_set_text(position[1], position[2]-1, position[3]-1, position[2]-1, colEnd, {"("..txt[1]..")"})
    end,
    ['['] = function ()
      vim.api.nvim_buf_set_text(position[1], position[2]-1, position[3]-1, position[2]-1, colEnd, {"["..txt[1].."]"})
    end,
    ["'"] = function ()
      vim.api.nvim_buf_set_text(position[1], position[2]-1, position[3]-1, position[2]-1, colEnd, {"'"..txt[1].."'"})
    end,
    ['"'] = function ()
      vim.api.nvim_buf_set_text(position[1], position[2]-1, position[3]-1, position[2]-1, colEnd, {"\""..txt[1].."\""})
    end,
  }
  if cases[key] then
    cases[key]()
    vim.api.nvim_input("<Esc>")
  else
    print "This key does not exist"
  end
end)

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
-- Avoid some incompatibilities in vi
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
-- It is set of in my config but this will help to avoid issues on not really 
-- junping lines when wraped
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

