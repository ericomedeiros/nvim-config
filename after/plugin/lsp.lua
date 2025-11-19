vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(_, bufnr)

    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

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
