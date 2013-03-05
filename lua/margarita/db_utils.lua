----
-- Database utils
----
-- part of Margarita3 project
-- (c) Severák 2012
-- License: MIT
----
require 'luasql.sqlite3'
local env=luasql.sqlite3()

local function quote(input)
	if tonumber(input) then
		return tostring(tonumber(input))
	elseif type(input)=='string' then
		return string.format("'%s'", string.gsub(input, "'", "''"))
	elseif input==nil then
		return 'NULL'
	end
end

local wrap_proto={}

function wrap_proto:rows(sql)
	local cursor = assert (self.connection:execute (sql))
	local tabl = {}
	return function ()
		local data=cursor:fetch(tabl, 'a')
		if data then
			return data
		else
			cursor:close()
		end
	end
end

function wrap_proto:get_pairs(sql)
	local ret={}
	local cursor = assert (self.connection:execute (sql))
	local row=cursor:fetch({}, 'n')
	while row do
		ret[ row[1] ]=row[2]
		row=cursor:fetch(row, 'n')
	end
	cursor:close()
	return ret
end

function wrap_proto:execute(sql)
	return self.connection:execute (sql)
end

function wrap_proto:insert(table_name, data)
	local colnames={}
	local coldata={}
	for k,v in pairs(data) do
		colnames[#colnames+1] = quote(k)
		coldata[#coldata+1] = quote(v)
	end
	local sql = string.format(
		'INSERT INTO %s (%s) VALUES (%s)',
		table_name,
		table.concat(colnames, ','),
		table.concat(coldata, ',')
	)
	return self.connection:execute(sql)
end

local _M={}

function _M.wrap(filename)
	local ret={}
	ret.connection=assert(env:connect(filename))
	setmetatable(ret, {__index=wrap_proto})
	return ret
end

_M.quote=quote

return _M