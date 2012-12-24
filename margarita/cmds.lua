----
-- Commands
----
-- part of Margarita3 project
-- (c) Severák 2012
-- License: MIT
----
local model=require 'margarita.model'	

local _M={}

function _M.ver()
	print(string.format('Margarita v %d.%d', margarita.version.major, margarita.version.minor))
end

function _M.init(args)
	local fn=args[1] or error('Musite uvest nazev souboru!')
	local f=io.open(fn,'rb')
	if f then
		f:close()
		print(string.format('Soubor `%s` uz existuje!', fn))
		return
	end
	local db=db_utils.wrap(fn)
	for sql in string.gmatch(model.schema, '([^;]+)') do
		db:execute(sql)
	end
	db:close()
	f=io.open('margarita.wdb','w')
	f:write(fn)
	f:close()
	print(string.format('Databaze `%s` vytvorena a prepnuto do ni.', fn) )
end

function _M.open(args)
	local fn=args[1] or error('Musite uvest nazev souboru!')
	local f=io.open(fn, 'rb')
	if not f then
		print(string.format('Soubor `%s` neexistuje!'))
		return
	else
		f:close()
	end
	local db=db_utils.wrap(fn)
	local db_is_ok, db_error=model.check_db(db)
	if not db_is_ok then
		print(db_error)
		return
	end
	f=io.open('margarita.wdb','w')
	f:write(fn)
	f:close()
	print(string.format('Prepnuto do databaze `%s`.', fn) )
end

function _M.routes()
	local agencies=margarita.db:get_pairs('SELECT agency_id, agency_name FROM agency')
	for r in margarita.db:rows('SELECT * FROM routes') do
		print(r.route_short_name)
		print(string.format('%s [%s] (%s)', r.route_short_name, r.route_id, agencies[r.agency_id]))
	end
end

return _M