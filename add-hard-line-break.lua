-- Round Numbers - 小数取整
-- clip 和 drawing 中小数四舍五入取整
-- Copyright (c) 2017, mixj93 <mixj93@163.com>

local tr = aegisub.gettext

script_name = tr"Add Hard Line Break - 添加硬换行"
script_description = tr"在行首添加硬换行符"
script_author = "mixj93"
script_version = "1"

function add_hard_line_break(subs, sel)
    for _, i in ipairs(sel) do
        local line = subs[i]
        local hard_line_break = "\\N"
        line.text = hard_line_break..line.text
        subs[i] = line
    end
    aegisub.set_undo_point(tr"add_hard_line_break")
end

aegisub.register_macro(script_name, script_description, add_hard_line_break)
