----
-- Main executable
----
-- part of Margarita3 project
-- (c) Severák 2012
-- License: MIT
----
local cmds=require "margarita.cmds"
db_utils=require "margarita.db_utils"
margarita={}

margarita.version={
	major=3,
	minor=1
}

function margarita.main(arg)
	local cmd=table.remove(arg, 1)
	local f=io.open('margarita.wdb')
	local db_fn=':memory:'
	if f then
		db_fn=f:read('*a')
		f:close()
	end
	local db_exists=io.open(db_fn,'rb')
	if db_exists then
		db_exists:close()
		margarita.db=db_utils.wrap(db_fn)
	else
		if not (cmd=='init' or cmd=='open') then
			print(string.format('Chyba! Soubor `%s` neexistuje!',db_fn))
			return
		end
	end
	if type(cmds[cmd])=="function" then
		local ok, msg = pcall(cmds[cmd], arg)
		if not ok then
			print(msg)
		end
	else
		print(string.format('Neznamy prikaz: `%s` ', cmd))
	end
end

margarita.main(arg)
