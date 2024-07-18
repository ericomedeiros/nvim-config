local obs = require('obsidian').get_client()

vim.keymap.set("n", "<leader>ocn", function()
  local t = vim.fn.input('Note name: ')
  vim.print(t)
  local note = obs.create_note(obs, { title = t, id = t })
  obs.open_note(obs, note)
end)
