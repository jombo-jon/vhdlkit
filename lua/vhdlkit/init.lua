
-- print("VHDL Tool Kit")

local ui = require("vhdlkit.ui")
--
local vhdlkit = {}

-- Functions Definition
function vhdlkit.setup(opts)

  opts = opts or {}

  -- --------------------------
  -- Defautl Snips
  -- require("vhdlkit.snips")

  -- --------------------------
  -- Defautl Keymaps
  vim.api.nvim_set_keymap('n','<Leader>comp',':lua require("vhdlkit").get_component()<CR>', {})
  vim.api.nvim_set_keymap('n','<Leader>map',':lua require("vhdlkit").get_component_map()<CR>', {})

  -- Requires GHDL and Make file
  -- ghdl -s --iee=synopsys src/a.vhd --workdir=work/ --work=work 
  vim.api.nvim_set_keymap('n','<s-b>','<Cmd>FloatermNew --wintype=normal --name=GHDLSyntax --autoclose=0 ghdl -s --ieee=synopsys --workdir=work/ --work=work/ %<CR>', {})
  --TODO: first a function that checks if there is a makefile in the directory ? or checks the ymal configuration file
  --for project

  
end

function vhdlkit.get_component ()
  opts = {}
  opts['title'] = "Get Component"
  opts['return'] = "normal \"cp"
  -- ui.toggle_quick_menu("Get Component")

  vim.fn.setreg("c","");
  ui.toggle_quick_menu(opts)
  vim.cmd('normal "cp')
end

function vhdlkit.get_component_map ()
  opts = {}
  opts['title'] = "Get Component Map"
  opts['return'] = "normal \"mp"

  vim.fn.setreg("m","");
  ui.toggle_quick_menu(opts)
  vim.cmd('normal "mp')
end

return vhdlkit
