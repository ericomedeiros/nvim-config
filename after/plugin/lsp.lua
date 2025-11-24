vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(_, bufnr)

    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

-- lsp.ensure_installed({
--   'tsserver',
--   'eslint',
--   'html',
--   'lua_ls',
-- })
--
-- local lsp_configurations = require('lspconfig.configs')
--
-- if not lsp_configurations.cds_lsp then
--   lsp_configurations.cds_lsp = {
--     default_config = {
--       name = 'cds_lsp',
--       cmd = {
--         "node",
--         '/Users/i505805/apps/node_modules/.bin/cds-lsp',
--         '--stdio'
--       },
--       filetypes = {'cds'},
--       root_dir = require('lspconfig.util').root_pattern('package.json', '.git') or vim.loop.os_homedir()
--       -- root_dir = "${HOME}/apps/node_modules/.bin/cds-lsp",
--     }
--   }
-- end
--
-- require('lspconfig').cds_lsp.setup({
--   on_attach=function (client, bufnr)
--     if client.definition then
--       vim.keymap.set('n', 'gd', client.definition(), { buffer = bufnr, desc = '', remap = false })
--     end
--   end
-- })
-- -- Fix Undefined global 'vim'
-- lsp.nvim_workspace()
--
-- lsp.on_attach(function(client, bufnr)
--    -- NOTE: Remember that lua is a real programming language, and as such it is possible
--   -- to define small helper and utility functions so you don't have to repeat yourself
--   -- many times.
--   --
--   -- In this case, we create a function that lets us more easily define mappings specific
--   -- for LSP related items. It sets the mode, buffer and description for us each time.
--   local nmap = function(keys, func, desc)
--     if desc then
--       desc = 'LSP: ' .. desc
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, remap = false })
    end

    -- global defaults override
    if vim.fn.maparg('gra') ~= '' then
      print(vim.fn.maparg('gra'))
      vim.keymap.del({'n','v'}, 'gra', {})
    end
    if vim.fn.maparg('gri') ~= '' then
      vim.keymap.del({'n'}, 'gri', {}) -- vim.lsp.buf.implementation()
    end
    if vim.fn.maparg('grn','n') ~= '' then
      vim.keymap.del({'n'}, 'grn', {})
    end
    if vim.fn.maparg('grr','n') ~= '' then
      vim.keymap.del({'n'}, 'grr', {})
    end
    if vim.fn.maparg('grt','n') ~= '' then
      vim.keymap.del({'n'}, 'grt', {})
    end

    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('<leader>td', vim.lsp.buf.type_definition, '[T]ype [D]efinition')
    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap("<C-f>", vim.lsp.buf.format, '[F]ormat')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation') -- See `:help K` for why this keymap
    nmap('<leader>i', require('telescope.builtin').lsp_implementations, '[I]mplementation')
    nmap("<leader>rr", require('telescope.builtin').lsp_references, '[R]eferences [R]eferences')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap("gld", vim.diagnostic.open_float, '[G]o [L]ine [D]iagnostic')

    -- Diagnostics remap
    nmap("<leader>vws", vim.lsp.buf.workspace_symbol, '[V]iew [W]orkspace [S]ymbols')
    nmap('<leader>q', vim.diagnostic.setloclist, 'Open diagnostics list')
    vim.keymap.set('n', '<leader>fd', function()
      require('telescope.builtin').diagnostics({ bufnr=0, no_unlisted=true, severity_bound = 0 })
    end, { desc = '[F]ile [D]iagnostics' })
    

    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')


    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')
  end
})
