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
       local stdout = function(err,data)
           if err then
               print(err)
           else
               print(data)
           end
       end
       if string.find(dir,'/flows/') then
          local deleteFlows = function ()
              vim.system({'deleteFlows.sh',dir},{stdout = stdout, stderr = stdout})
          end
          -- This is a flow, ensure it's deactivated and then delete all versions
          print('Flow found, deactivating then deleting')
          vim.system({'deactivateFlows.sh',dir},{stdout = stdout, stderr = stdout},deleteFlows)
       end
       print(dir)
    end,
    {}
)

