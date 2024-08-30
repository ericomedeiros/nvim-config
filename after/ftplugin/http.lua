vim.keymap.set({'n','v'}, '<leader>mr', function ()
  local curlCmd = "curl -X "
  curlCmd = curlCmd .. vim.api.nvim_get_current_line()
  curlCmd = curlCmd:gsub("?", "\\?")
  vim.print(curlCmd)
  local se = vim.fn.search('###','cn') - 1
  local req = vim.api.nvim_buf_get_lines(0, (vim.fn.line('.')), se, false)
  local inHeader = true
  for key, value in ipairs(req) do
    vim.print(value:match("%S"))
    if value:match("%S") ~= nil then
      if value == "{" then
        curlCmd = curlCmd:sub(1,-3) .. " -D '"
        inHeader = false
      end
      curlCmd = curlCmd  .. " -H '" .. value .. "'"
      
      if value == "}" then
        curlCmd = curlCmd .. "'"
        break
      end
    end
  end
  if inHeader then
    curlCmd = curlCmd:sub(1,-3) .. "'"
  end
  vim.print(curlCmd)
  vim.cmd("vnew")
  vim.cmd(":terminal "..curlCmd)
end, {desc = '[M]ake [R]equest'})
