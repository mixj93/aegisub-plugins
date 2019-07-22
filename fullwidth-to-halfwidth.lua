-- Fullwidth to halfwidth - 全角转半角
-- 把全角的字母、数字转为半角字符，符号也转为常见的符号
-- Copyright (c) 2017, mixj93 <mixj93@163.com>

local tr = aegisub.gettext

script_name = tr("Fullwidth to halfwidth - 全角转半角")
script_description = tr("把全角的字母、数字转为半角字符，符号也转为常见的符号")
  script_author = "mixj93"
  script_version = "1"

include("unicode.lua")

-- lookup = {
-- 	['!'] = '！', ['"'] = '”', ['#'] = '＃', ['$'] = '＄', 
-- 	['%'] = '％', ['&'] = '＆', ["'"] = '’', ['('] = '（', 
-- 	[')'] = '）', ['*'] = '＊', ['+'] = '＋', [','] = '，', 
-- 	['-'] = '－', ['.'] = '．', ['/'] = '／',
-- 	['1'] = '１', ['2'] = '２', ['3'] = '３', ['4'] = '４', 
-- 	['5'] = '５', ['6'] = '６', ['7'] = '７', ['8'] = '８', 
-- 	['9'] = '９', ['0'] = '０',
-- 	[':'] = '：', [';'] = '；', ['<'] = '＜', ['='] = '＝', 
-- 	['>'] = '＞', ['?'] = '？', ['@'] = '＠',
-- 	['A'] = 'Ａ', ['B'] = 'Ｂ', ['C'] = 'Ｃ', ['D'] = 'Ｄ', 
-- 	['E'] = 'Ｅ', ['F'] = 'Ｆ', ['G'] = 'Ｇ', ['H'] = 'Ｈ', 
-- 	['I'] = 'Ｉ', ['J'] = 'Ｊ', ['K'] = 'Ｋ', ['L'] = 'Ｌ', 
-- 	['M'] = 'Ｍ', ['N'] = 'Ｎ', ['O'] = 'Ｏ', ['P'] = 'Ｐ', 
-- 	['Q'] = 'Ｑ', ['R'] = 'Ｒ', ['S'] = 'Ｓ', ['T'] = 'Ｔ', 
-- 	['U'] = 'Ｕ', ['V'] = 'Ｖ', ['W'] = 'Ｗ', ['X'] = 'Ｘ', 
-- 	['Y'] = 'Ｙ', ['Z'] = 'Ｚ',
-- 	['['] = '［', ['\\'] = '＼', [']'] = '］', ['^'] = '＾', 
-- 	['a'] = 'ａ', ['b'] = 'ｂ', ['c'] = 'ｃ', ['d'] = 'ｄ', 
-- 	['e'] = 'ｅ', ['f'] = 'ｆ', ['g'] = 'ｇ', ['h'] = 'ｈ', 
-- 	['i'] = 'ｉ', ['j'] = 'ｊ', ['k'] = 'ｋ', ['l'] = 'ｌ', 
-- 	['m'] = 'ｍ', ['n'] = 'ｎ', ['o'] = 'ｏ', ['p'] = 'ｐ', 
-- 	['q'] = 'ｑ', ['r'] = 'ｒ', ['s'] = 'ｓ', ['t'] = 'ｔ', 
-- 	['u'] = 'ｕ', ['v'] = 'ｖ', ['w'] = 'ｗ', ['x'] = 'ｘ', 
-- 	['y'] = 'ｙ', ['z'] = 'ｚ',
-- 	['_'] = '＿', ['`'] = '‘',
-- 	['{'] = '｛', ['|'] = '｜', ['}'] = '｝', ['~'] = '～', 
-- }

lookup = {
  ['１'] = '1', ['２'] = '2', ['３'] = '3', ['４'] = '4', 
	['５'] = '5', ['６'] = '6', ['７'] = '7', ['８'] = '8', 
  ['９'] = '9', ['０'] = '0',
  ['Ａ'] = 'A', ['Ｂ'] = 'B', ['Ｃ'] = 'C', ['Ｄ'] = 'D', 
	['Ｅ'] = 'E', ['Ｆ'] = 'F', ['Ｇ'] = 'G', ['Ｈ'] = 'H', 
	['Ｉ'] = 'I', ['Ｊ'] = 'J', ['Ｋ'] = 'K', ['Ｌ'] = 'L', 
	['Ｍ'] = 'M', ['Ｎ'] = 'N', ['Ｏ'] = 'O', ['Ｐ'] = 'P', 
	['Ｑ'] = 'Q', ['Ｒ'] = 'R', ['Ｓ'] = 'S', ['Ｔ'] = 'T', 
	['Ｕ'] = 'U', ['Ｖ'] = 'V', ['Ｗ'] = 'W', ['Ｘ'] = 'X', 
	['Ｙ'] = 'Y', ['Ｚ'] = 'Z',
	['ａ'] = 'a', ['ｂ'] = 'b', ['ｃ'] = 'c', ['ｄ'] = 'd', 
	['ｅ'] = 'e', ['ｆ'] = 'f', ['ｇ'] = 'g', ['ｈ'] = 'h', 
	['ｉ'] = 'i', ['ｊ'] = 'j', ['ｋ'] = 'k', ['ｌ'] = 'l', 
	['ｍ'] = 'm', ['ｎ'] = 'n', ['ｏ'] = 'o', ['ｐ'] = 'p', 
	['ｑ'] = 'q', ['ｒ'] = 'r', ['ｓ'] = 's', ['ｔ'] = 't', 
	['ｕ'] = 'u', ['ｖ'] = 'v', ['ｗ'] = 'w', ['ｘ'] = 'x', 
	['ｙ'] = 'y', ['ｚ'] = 'z',
  ['－'] = '-', ['‥'] = '…', ['＂'] = '"'
}

function transform(subtitles, selected_lines, active_line)
	for z, i in ipairs(selected_lines) do
		local l = subtitles[i]
		
		aegisub.debug.out(string.format('Processing line %d: "%s"\n', i, l.text))
		aegisub.debug.out("Chars: \n")
		
		local in_tags = false
		local newtext = ""
		for c in unicode.chars(l.text) do
			aegisub.debug.out(5, c .. ' -> ')
			if c == "{" then
				in_tags = true
			end
			if in_tags then
				aegisub.debug.out(5, c .. " (ignored, in tags)\n")
				newtext = newtext .. c
			else
				if lookup[c] then
					aegisub.debug.out(5, lookup[c] .. " (converted)\n")
					newtext = newtext .. lookup[c]
				else
					aegisub.debug.out(5, c .. " (not found in lookup)\n")
					newtext = newtext .. c
				end
			end
			if c == "}" then
				in_tags = false
			end
		end
		
		l.text = newtext
		subtitles[i] = l
	end
	aegisub.set_undo_point(tr"Fullwidth to halfwidth - 全角转半角")
end

aegisub.register_macro(tr"Fullwidth to halfwidth - 全角转半角", tr"把全角的字母、数字转为半角字符，符号也转为常见的符号", transform)
