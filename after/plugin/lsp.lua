local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'html',
  'lua_ls',
})

local lsp_configurations = require('lspconfig.configs')

if not lsp_configurations.cds_lsp then
  lsp_configurations.cds_lsp = {
    default_config = {
      name = 'cds_lsp',
      cmd = {
        "node",
        '/Users/i505805/apps/node_modules/.bin/cds-lsp',
        '--stdio'
      },
      filetypes = {'cds'},
      root_dir = require('lspconfig.util').root_pattern('package.json', '.git') or vim.loop.os_homedir()
      -- root_dir = "${HOME}/apps/node_modules/.bin/cds-lsp",
    }
  }
end

require('lspconfig').cds_lsp.setup({
  on_attach=function (client, bufnr)
    vim.keymap.set('n', 'gd', client.definition(), { buffer = bufnr, desc = '', remap = false })
  end
})
-- Fix Undefined global 'vim'
lsp.nvim_workspace()

lsp.on_attach(function(client, bufnr)
   -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, remap = false })
  end

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

  -- Diagnostics remap
  nmap("<leader>vws", vim.lsp.buf.workspace_symbol, '[V]iew [W]orkspace [S]ymbols')
  nmap("<leader>vd", vim.diagnostic.open_float, '[V]iew [D]iagnostic')
  nmap('<leader>q', vim.diagnostic.setloclist, 'Open diagnostics list')
  nmap("[d", function() vim.diagnostic.goto_next() end, 'Go to next diagnostic message')
  nmap("]d", function() vim.diagnostic.goto_prev() end, 'Go to previous diagnostic message')

  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap("<leader>vrr", vim.lsp.buf.references, '[V]iew [R]eferences [R]eferences')

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- See `:help K` for why this keymap
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')


  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  -- in case of cds_lsp it does not support go to declaration
  if client.supports_method('textDocument/declaration') then
    vim.cmd('autocmd CursorHold <buffer> lua vim.lsp.buf.definition()')
  end
end)

lsp.setup()

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'luasnip'},
  },
  mapping = cmp.mapping.preset.insert({
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
      -- Ctrl+Space to trigger completion menu
      ["<C-Space>"] = cmp.mapping.complete(),
      -- `Enter` key to confirm completion
      ['<CR>'] = cmp.mapping.confirm({ select = true }),

      -- Navigate between snippet placeholder
      ['<C-f>'] = cmp_action.luasnip_jump_forward(),
      ['<C-b>'] = cmp_action.luasnip_jump_backward(),

      -- Scroll up and down in the completion documentation
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
  })
})

