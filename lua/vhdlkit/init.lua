
print("VHDL Tool Kit")

local ui = require("vhdlkit.ui")
require("vhdlkit.snips")

local M ={}

function M.get_component()
  ui.toggle_quick_menu("Get Component")
  vim.cmd('normal "cp')
end

function M.get_instantiation()
  ui.toggle_quick_menu("Get Instantiation")
  vim.cmd('normal "mp')
end

return M

