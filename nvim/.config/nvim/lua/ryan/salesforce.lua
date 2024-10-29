-- vim.keymap.set('n', '<leader>ga', ':silent !sf apex generate class -d  fh 
-- vim.keymap.set('n', '<leader>ga', ':silent !sf apex generate class -d  fh 
vim.keymap.set('n', '<leader>sfo', ':SFOpen<CR>')

local stdout = function(err,data)
   if err then
       print(err)
   elseif data then
       print(data)
   end
end

local mapOutput = {stdout = stdout, stderr = stdout}
vim.api.nvim_create_user_command('SFOpen',
    function ()
       local dir = vim.fn.expand('%')
       vim.system({'sf','org','open','-f',dir,},mapOutput)
    end,
    {}
)
vim.api.nvim_create_user_command('SFDeleteFile',
    function ()
       local dir = vim.fn.expand('%')
       if string.find(dir,'/flows/') then
          local deleteFlows = function ()
              vim.system({'deleteFlows.sh',dir},mapOutput)
          end
          -- This is a flow, ensure it's deactivated and then delete all versions
          print('Flow found, deactivating then deleting')
          vim.system({'deactivateFlows.sh',dir},mapOutput,deleteFlows)
       else 
           vim.system({'sf','project','delete','source','-p',dir,'-r'},mapOutput)
       end
       print(dir)
    end,
    {}
)

vim.api.nvim_create_user_command('SFDeploy',
    function ()
        local dir = vim.fn.expand('%')
        vim.system({'sf','project','deploy','start','-d',dir,'-c'},mapOutput)
    end,
    {}
)

vim.api.nvim_create_user_command('SFRetrieve',
    function ()
        local dir = vim.fn.expand('%')
        vim.system({'sf','project','retrieve','start','-d',dir,'-c'},mapOutput)
    end,
    {}
)

