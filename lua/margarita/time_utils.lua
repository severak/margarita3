----
-- Time utils
----
-- part of Margarita3 project
-- (c) Severák 2012
-- License: MIT
----

local M={}

M.MINUTE = 60
M.HOUR = 60*60
M.DAY = 24*60*60


M.to_number = function(time)
	local hh, mm, ss = 0, 0, 0
	if string.match(time, '^%d+:%d+$') then
		hh, mm = string.match(time, '(%d+):(%d+)')
		ss=0
	elseif string.match(time, '^%d+:%d+:%d+$') then
		hh, mm, ss = string.match(time, '(%d+):(%d+):(%d+)')
	else
		error('bad time format')
	end
	return (hh*60*60)+(mm*60)+ss
end
	
M.to_parts = function(number)
	local ret={}
	ret.hh = math.floor(number / M.HOUR)
	ret.mm = math.floor( (number % M.HOUR) / M.MINUTE )
	ret.ss = math.floor( number % M.HOUR % M.MINUTE )
	return ret
end
	
M.to_time = function(number)
	local p=M.to_parts(number)
	return string.format('%02d:%02d:%02d', p.hh, p.mm, p.ss)
end

M.add = function(a, b)
	return M.to_time(M.to_number(a) + M.to_number(b))
end


return M