return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        local ts = require('nvim-treesitter')

        ts.setup()

        ts.install({
            'c',
            'lua',
            'vim',
            'vimdoc',
            'query',
            'apex',
            'javascript',
            'typescript',
            'elixir',
            'heex',
            'html',
        })

        vim.api.nvim_create_autocmd('FileType', {
            desc = 'Enable Treesitter highlighting and indent',
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}

