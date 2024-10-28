-- vim.keymap.set('n', '<leader>ga', ':silent !sf apex generate class -d  fh 
-- vim.keymap.set('n', '<leader>ga', ':silent !sf apex generate class -d  fh 
vim.keymap.set('n', '<leader>sfo', ':SFOpen<CR>')
vim.api.nvim_create_user_command('SFOpen',
    function ()
       local dir = vim.fn.expand('%')
       vim.system({'sf','org','open','-f',dir,})
    end,
    {}
)
vim.api.nvim_create_user_command('SFDeleteFile',
    function ()
       local dir = vim.fn.expand('%')
       if string.find(dir,'/flow/') then
          -- This is a flow, ensure it's deactivated and then delete all versions
          vim.system('deactivateFlows',dir,{},function()
              vim.system('deleteFlows',dir)
          end)
       end

    end,
    {}
)

