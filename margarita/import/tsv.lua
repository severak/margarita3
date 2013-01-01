----
-- TSV import
----
-- part of Margarita3 project
-- (c) Severák 2012
-- License: MIT
----
local data = require "pl.data"
local utils = require "pl.utils"
local pretty = require "pl.pretty"
local eater={}

function eater.stops(fname)
	local stops=data.read(fname, {delim='\t'})
	pretty.dump(stops)
end


return function(args)
	local entity=table.remove(args, 1 ) or error('Prvni parametr je typ enetity.')
	local fname=table.remove(args, 1 ) or error('Druhy parametr je nazev souboru.')
	if type(eater[entity])=='function' then
		eater[entity](fname)
	else
		print(string.format('Naznamy typ entity `%s`', entity))
	end
end