return {
    'L3MON4D3/LuaSnip',
    config = function ()
        local ls = require "luasnip"
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node

        ls.config.set_config {
            history = false,
            updateevents = 'TextChanged,TextChangedI',
            enable_autosnippets = false
        }

        vim.keymap.set({"i","s"}, "<c-k>", function ()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, {silent = true})

        ls.snippets = { "lua", {
            s("bob",{
                t('hello world '),
                i(1),
                t('wasssssupp'),
                i(2)
            })
        }}
    end
}

