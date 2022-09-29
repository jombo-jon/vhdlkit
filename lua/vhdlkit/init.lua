
print("VHDL Tool Kit")

local ui = require("vhdlkit.ui")
-- require("vhdlkit.snips")
--
local M = {}

M.setup = function(opts)
  
  config = function() require('vhdlkit.snips') end
end

M.get_component = function()
  opts = {}
  opts['title'] = "Get Component Map"
  opts['return'] = "normal \"cp"
  -- ui.toggle_quick_menu("Get Component")
  ui.toggle_quick_menu(opts)
  -- vim.cmd('normal "cp')
end

M.get_component_map = function()
  opts = {}
  opts['title'] = "Get Component Map"
  opts['return'] = "normal \"mp"

  ui.toggle_quick_menu(opts)
  -- vim.cmd('normal "mp')
end

-- vim.api.nvim_add_user_command('Upper', 'echo toupper(<q-args>)', { nargs = 0 })
-- vim.api.nvim_add_user_command('VHDLKit_Comp', M.get_component(), { nargs = 0 })
-- vim.api.nvim_add_user_command('VHDLKit_Map', M.get_component_map(), { nargs = 0 })
return M
