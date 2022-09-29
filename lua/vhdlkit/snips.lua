
local ls = require("luasnip")

local s = ls.s
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial

local ckit = require("vhdlkit").get_component
local mkit = require("vhdlkit").get_component_map

local same = function(args)
  return f(function(arg)
    return arg[1]
  end, {args})
end

local filename = function(_,snip) 
      local file = snip.env.TM_FILENAME 
      return file:match("(.*).vhd")
end 

-- ------------ SNIPPETS --------------

ls.add_snippets("vhdl", {

  s({trig = "comp", regTrig = true}, 
    -- t(kit.get_component()),
    -- t(ckit()),
    f(function ckit() end,{}),
    i(0)
  ),
  s({trig = "map", regTrig = true}, 
    f(function mkit() end,{}),
    i(0)
  ),
},
{
  key = "vhdl",
})
