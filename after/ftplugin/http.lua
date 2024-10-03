local line_count = vim.api.nvim_buf_line_count(0) -- Get total lines
vim.api.nvim_win_set_cursor(0, {line_count, 0})
local lastVariableLineMatch = vim.fn.search('^@','cnb')
vim.api.nvim_win_set_cursor(0,{1,0})
-- Get the current buffer's lines
local linesWithVariables = vim.api.nvim_buf_get_lines(0, 0, lastVariableLineMatch, false)
local fileVariables = {}

for _, line in ipairs(linesWithVariables) do
  local variableName = line:match("@(.+)=")
  local variableValue = line:match("=(.+)$")
  fileVariables[variableName] = variableValue
end

local function processVariable(line)
  assert(type(line) == "string", "the line should be a string")
  for w in line:gmatch("{{(.+)}}") do
    vim.print(w)
    if fileVariables[w] ~= nil then
      line = line:gsub("{{"..w.."}}",fileVariables[w])
    end
  end
  return line
end

local function whenJobEventStdout(data)
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

local function whenJobEventStderr(data)
  local responseBuf = vim.api.nvim_create_buf(true,false)
  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(0,responseBuf)
  vim.api.nvim_buf_set_lines(responseBuf, 0, -1, false, data)
end

local function processJobEvents(_, data, eventName)
  if data[1]:match("%S") == nil then
    vim.print("I'm out")
    return
  elseif eventName == "stdout" then
    whenJobEventStdout(data)
  elseif eventName == "stderr" then
    whenJobEventStderr(data)
  end
end

vim.keymap.set({'n','v'}, '<leader>mr', function ()
  local curlCmd = "curl -X "
  curlCmd = curlCmd .. processVariable(vim.api.nvim_get_current_line())
  curlCmd = curlCmd:gsub("?", "\\?") -- avoid shell not getting ?
  local requestEndLine = vim.fn.search('###','cn') - 1
  local requestLines = vim.api.nvim_buf_get_lines(0, (vim.fn.line('.')), requestEndLine, false)
  local inHeader = true
  for _, value in ipairs(requestLines) do
    if inHeader and  value:match("%S") == nil then
      inHeader = false
    end
    if not inHeader and value == "{" then
      curlCmd = curlCmd:sub(1,-2) .. " -d '{"
    elseif not inHeader and value == "}" then
      curlCmd = curlCmd .. "}'"
      break
    elseif inHeader then
      curlCmd = curlCmd  .. " -H '" .. processVariable(value) .. "'"
    else
      curlCmd = curlCmd .. processVariable(value)
    end
  end

  if inHeader and requestLines[1]:match("%S") ~= nil then
    curlCmd = curlCmd:sub(1,-3) .. "'"
  end

  vim.fn.jobstart(curlCmd,{
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = processJobEvents,
    on_stderr = processJobEvents
  })
end, {desc = '[M]ake [R]equest'})
