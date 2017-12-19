-- Round Numbers - 小数取整
-- clip 和 drawing 中小数四舍五入取整
-- Copyright (c) 2017, mixj93 <mixj93@163.com>

local tr = aegisub.gettext

script_name = tr"Add Special Characters - 添加特殊符号"
script_description = tr"在行首或行尾添加特殊符号"
script_author = "mixj93"
script_version = "1"

function add_hard_line_break(subtitles, selected_lines, active_line)
    config = {
        {class="label", x=0, y=0, width=30, height=1},
        {class="label", label="位置:", x=1, y=1, width=5, height=1},
        {class="dropdown", name="position", items={"行首", "行尾"}, value="行首", x=11, y=1, width=10, height=1},
        {class="label", label="符号:", x=1, y=2, width=5, height=1},
        {class="dropdown", name="symbol", items={"硬换行 \\N", "软换行 \\n", "硬空格 \\h"}, value="硬换行 \\N", x=11, y=2, width=10, height=1}
    }
    buttons = {"确定", "取消"}
    button_ids = {ok="确定", cancel="取消"}
    btn, result = aegisub.dialog.display(config, buttons, button_ids)
    if btn then
        local pos = result.position
        local sym
        if( result.symbol == "软换行 \\n" )
        then
            sym = "\\n"
        elseif( result.symbol == "硬空格 \\h" )
        then
            sym = "\\h"
        else
            sym = "\\N"
        end
        for _, i in ipairs(selected_lines) do
            local line = subtitles[i]
            if(pos == "行尾")
            then
                line.text = line.text..sym
            else
                line.text = sym..line.text
            end
            subtitles[i] = line
        end
        aegisub.set_undo_point(tr"add_hard_line_break")
    end
end

aegisub.register_macro(script_name, script_description, add_hard_line_break)
