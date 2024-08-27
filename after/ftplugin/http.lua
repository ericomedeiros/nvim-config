vim.keymap.set({'n','v'}, '<leader>mr', function ()
  local curLine = vim.api.nvim_get_current_line()
  vim.print(curLine)
  local se = vim.fn.search('###','cn') - 1
  vim.print(se)
  local req = vim.api.nvim_buf_get_lines(0, (vim.fn.line('.') - 1), se, false)
  vim.print(req)
end, {desc = '[M]ake [R]equest'})
