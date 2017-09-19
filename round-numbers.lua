-- Round Numbers - 小数取整
-- clip 和 drawing 中小数四舍五入取整
-- Copyright (c) 2017, mixj93 <mixj93@163.com>

local tr = aegisub.gettext

script_name = tr"Round Numbers - 小数取整"
script_description = tr"clip 和 drawing 中小数四舍五入取整"
script_author = "mixj93"
script_version = "1"

function round_numbers(subs, sel)
    for _, i in ipairs(sel) do
        local line = subs[i]
        -- aegisub.debug.out(i..": "..line.text.."\n")
        local newText = cleanClipStr(line.text)
        newText = cleanDrawStr(newText)
        line.text = newText
        subs[i] = line
    end
    aegisub.set_undo_point(tr"round_numbers")
end

function cleanClipStr(str)
    local newStr = str
    for clipStr in string.gmatch(str, "\\clip%([^%)]+%)") do
        for numStr in string.gmatch(clipStr, "[%d%.]+") do
            local oriNum = tonumber(numStr)
            local resNum = round(oriNum)
            if numStr ~= tostring(resNum)
            then
                newStr = string.gsub(newStr, numStr, tostring(resNum), 1)
            end
        end
    end
    return newStr
end

function cleanDrawStr(str)
    local newStr = str
    for drawStr in string.gmatch(newStr, "}[^}]+{\\p0}") do
        for numStr in string.gmatch(drawStr, "[%d%.]+") do
            local oriNum = tonumber(numStr)
            local resNum = round(oriNum)
            if numStr ~= tostring(resNum)
            then
                newStr = string.gsub(newStr, numStr, tostring(resNum), 1)
            end
        end
    end
    return newStr
end

function round(x)
    if x%2 ~= 0.5
    then
        return math.floor(x+0.5)
    end
    return x-0.5
end

aegisub.register_macro(script_name, script_description, round_numbers)
