
local popup = require("plenary.popup")
local M = {}

--Window Variables
win_id = nil
win_bufh = nil
contents = nil

local function create_window(win_title)
    print("_create_window()")
    -- local config = harpoon.get_menu_config()
    local config = {}
    local width = config.width or 60
    local height = config.height or 10
    local borderchars = config.borderchars
        or { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local bufnr = vim.api.nvim_create_buf(false, false)

    local win_id, win = popup.create(bufnr, {
        title = win_title,
        highlight = "HarpoonWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
    })

    vim.api.nvim_win_set_option(
        win.border.win_id,
        "winhl",
        "Normal:HarpoonBorder"
    )

    return {
        bufnr = bufnr,
        win_id = win_id,
    }
end

local function scandir()
  -- print(vim.inspect(vim.fn.system('tree src -fi')))
  local files = vim.fn.systemlist('ls src/ -1')
  print(vim.inspect(files))
  return files
  -- vim.fn.system('./test.sh')
  -- print(vim.inspect(vim.fn.system('tree . -J')))
  
    -- local i, t, popen = 0, {}, io.popen
    -- local pfile = popen('ls -a "'..directory..'"')
    -- for filename in pfile:lines() do
    --     i = i + 1
    --     t[i] = filename
    -- end
    -- pfile:close()
    -- return t
end

local function close_menu()
    -- force_save = force_save or false
    -- local global_config = harpoon.get_global_settings()

    -- if global_config.save_on_toggle or force_save then
    --     require("harpoon.ui").on_menu_save()
    -- end

    vim.api.nvim_win_close(win_id, true)

    win_id = nil
    win_bufh = nil
end


function M.select_menu_item()
    local idx = vim.fn.line(".")
    close_menu()

    local filename = "src/"..contents[idx]

    file = io.open(filename,"r")

    -- Retrieve the Component Name
    local arr = {}
    local flg = false
    for line in file:lines() do

      if string.find(line, "end [%w%d_-]*.;") then
        table.insert(arr,"end component;")
        break
      end

      if flg == true then
        table.insert(arr,line)
      end

      if string.find(line, "entity [%w%d_-]* is") then
        flg = true;
        s = string.gsub(line,"entity","component")
        table.insert(arr,s)
      end
    end
    file:close()

    -- Select the file read it and retrieve  the information and save
    -- Map select the generics and the ports only
    map = {}
    for _,line in ipairs(arr) do

      if string.find(line, "component [%w%d_-]* is") then
        patterns = {"component", "is", " "}
        for i,v in ipairs(patterns) do
          line = string.gsub(line, v, "")
        end
        table.insert(map, "_ : " .. line)

      elseif string.find(line, "generic") then
        table.insert(map,"generic map(")

      elseif string.find(line, "port") then
        --remove comma from last element
        map[#map] = map[#map]:sub(1,-2) 
        table.insert(map,")")
        table.insert(map,"port map(")

      elseif string.find(line, "[%w%d_-]*.:.*") then
        patterns = {"constant", " ", ":.*"}
        for i,v in ipairs(patterns) do
          line = string.gsub(line, v, "")
        end
        table.insert(map,"\t" .. line .. " =>  ,")
      end

    end
    map[#map] = map[#map]:sub(1,-2) 
    table.insert(map,");")
    print(map)
    vim.fn.setreg("c",arr);
    vim.fn.setreg("m",map);

    -- M.nav_file(idx)
end

function M.toggle_quick_menu(win_title)
    print("toggle_quick_menu("..win_title..")")
    if win_id ~= nil and vim.api.nvim_win_is_valid(win_id) then
        close_menu()
        return
    end
    local win_info = create_window(win_title)
    local global_config = {}

    contents = scandir()
    win_id = win_info.win_id
    win_bufh = win_info.bufnr

    -- Contents
    -- for idx = 1, Marked.get_length() do
    --     local file = Marked.get_marked_file_name(idx)
    --     if file == "" then
    --         file = "(empty)"
    --     end
    --     contents[idx] = string.format("%s", file)
    -- end

    vim.api.nvim_win_set_option(win_id, "number", true)
    vim.api.nvim_buf_set_name(win_bufh, "harpoon-menu")
    vim.api.nvim_buf_set_lines(win_bufh, 0, #contents, false, contents)
    vim.api.nvim_buf_set_option(win_bufh, "filetype", "harpoon")
    vim.api.nvim_buf_set_option(win_bufh, "buftype", "acwrite")
    vim.api.nvim_buf_set_option(win_bufh, "bufhidden", "delete")
    vim.api.nvim_buf_set_keymap(
        win_bufh,
        "n",
        "q",
        "<Cmd>lua require('vhdlkit.ui').toggle_quick_menu()<CR>",
        { silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        win_bufh,
        "n",
        "<ESC>",
        "<Cmd>lua require('vhdlkit.ui').toggle_quick_menu()<CR>",
        { silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        win_bufh,
        "n",
        "<CR>",
        "<Cmd>lua require('vhdlkit.ui').select_menu_item()<CR>",
        {}
    )
    -- vim.cmd(
    --     string.format(
    --         "autocmd BufWriteCmd <buffer=%s> lua require('harpoon.ui').on_menu_save()",
    --         Harpoon_bufh
    --     )
    -- )
    -- if global_config.save_on_change then
    --     vim.cmd(
    --         string.format(
    --             "autocmd TextChanged,TextChangedI <buffer=%s> lua require('harpoon.ui').on_menu_save()",
    --             Harpoon_bufh
    --         )
    --     )
    -- end
    -- vim.cmd(
    --     string.format(
    --         "autocmd BufModifiedSet <buffer=%s> set nomodified",
    --         Harpoon_bufh
    --     )
    -- )
    -- vim.cmd(
    --     "autocmd BufLeave <buffer> ++nested ++once silent lua require('harpoon.ui').toggle_quick_menu()"
    -- )
end
return M
