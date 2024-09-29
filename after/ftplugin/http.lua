local line_count = vim.api.nvim_buf_line_count(0) -- Get the total number of lines
vim.api.nvim_win_set_cursor(0, {line_count, 0})
local lastVariableLineMatch = vim.fn.search('^@','cnb')
vim.api.nvim_win_set_cursor(0,{1,0})
-- Get the current buffer's lines
local lines = vim.api.nvim_buf_get_lines(0, 0, lastVariableLineMatch, false)
local matching_lines = {}

-- Iterate through each line and match against the pattern
for _, line in ipairs(lines) do
  if line:match('^@') then
    -- table.insert(matching_lines, line)
      vim.print(line)
    for w in line:gmatch("^@(%w+)=(%w+)") do
      vim.print(w)
    end
  end
end

local function processVariable(line)
  assert(type(line) == "string", "the line should be a string")
  for w in line:gmatch("{{(%w+)}}") do
    vim.print(w)
  end
  
end

vim.print(matching_lines)
vim.keymap.set({'n','v'}, '<leader>mr', function ()
  local curlCmd = "curl -X "
  curlCmd = curlCmd .. vim.api.nvim_get_current_line()
  processVariable(vim.api.nvim_get_current_line())
  curlCmd = curlCmd:gsub("?", "\\?") -- avoid shell not getting ?
  local requestEndLine = vim.fn.search('###','cn') - 1
  local requestLines = vim.api.nvim_buf_get_lines(0, (vim.fn.line('.')), requestEndLine, false)
  local inHeader = true
  for _, value in ipairs(requestLines) do
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
  if inHeader and requestLines[1]:match("%S") ~= nil then
    curlCmd = curlCmd:sub(1,-3) .. "'"
  end
  vim.fn.jobstart(curlCmd,{
    stdout_buffered = true,
    on_stdout = function(channID, data, eventName)
      local curlResult = data[1]:gsub("\r", "")
      local responseBuf = vim.api.nvim_create_buf(true,false)
      vim.api.nvim_buf_set_option(responseBuf, "filetype", "json")
      local lines = {}
      for line in curlResult:gmatch("([^\n]*)\n?") do
        table.insert(lines, line)
      end
      vim.cmd("vsplit")
      vim.api.nvim_win_set_buf(0,responseBuf)
      vim.api.nvim_buf_set_lines(responseBuf, 0, -1, false, lines)
    end
  })
  -- local handle = io.popen(curlCmd)
  -- local result = handle:read("*a") -- Reads all output
  -- handle:close()
  -- vim.api.nvim_put(curlResult,"l",true,true)
end, {desc = '[M]ake [R]equest'})
