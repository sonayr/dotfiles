local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

ls.add_snippets("apex", {
    s({
        trig = 'header',
        desc = 'Gives a formatted apex header for every class type',
        name = 'Apex Class Header',
    },
    fmt(
        [[
        /******************************************************************************
        Author:{}
        Test Class(s):{}
        Description:{}
        Created:{}
        ******************************************************************************/
        ]],{i(1,'Ryan O\'Sullivan'),i(2),i(3),os.date('%Y-%m-%d')}
    )),
    s({
        trig = 'fori',
        desc = 'For loop with a integer',
        name = 'For Integer loop'
    },
    fmt(
        [[
        for( Integer {i} = 0 ; {i} {l} {c}, {i}++){{
        \{o}
        }}
        ]], 
        {
            i = i(1,'i'),
            l = i(2,'<'),
            c = i(3),
            o = i(0)
        },
        {
            indent_string = '\\',
            repeat_duplicates = true
        }
    )),
    s({
        trig = 'forl',
        desc = 'For loop with a list of records',
        name = 'For List loop'
    },
    fmt(
        [[
        for( {t} {n}: {l}){{
        \{o}
        }}
        ]],
        {
            t = i(1,'Account'),
            n = i(2,'oAcct'),
            l = i(3,'accounts'),
            o = i(0),
        },
        {
            indent_string = '\\'
        }
    ))
})
