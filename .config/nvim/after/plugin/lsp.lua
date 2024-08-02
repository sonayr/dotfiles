local lsp = require('lsp-zero')
lsp.preset("recommended")

lsp.setup_servers({
    'lua_ls',
    'eslint',
    'tsserver',
})


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({select = true}),
    ['<C-Space>'] = cmp.mapping.complete()
})
lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({buffer = bufnr})
end)
require('mason').setup({})
-- setup Salesforce lsp
vim.filetype.add({
    extension = {
        cls = 'apex',
        trigger = 'apex',
        apex = 'apex'
    },
    filename = {
        ['.cls'] = 'apex',
        ['.apex'] = 'apex',
        ['.trigger'] = 'apex'
    }
})

local lspconfig = require'lspconfig'
lspconfig.apex_ls.setup {
    apex_enable_semantic_errors = false,
    apex_enable_completion_statistics = false,
    filetypes = { 'apex' },
    root_dir = lspconfig.util.root_pattern('sfdx-project.json'),

    on_attach = on_attach,
    capabilities = capabilities,
}
require('mason-lspconfig').setup({
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({})
		end,
	},
})
