----
-- UI
----
-- part of Margarita3 project
-- (c) Severák 2013
-- License: MIT
----
local orbiter = require "orbiter"
local ui = orbiter.new()

function ui:set_db(db)
	self.db=db
end

function ui:index()
	return 'OK'
end

function ui:route(web)
	return 'ROUTE ' .. web.GET.name
end

function ui:meta()
	local p = self.db:get_pairs('SELECT * FROM margarita_meta')
	local ret = ''
	for k,v in pairs(p) do
		ret = ret .. k ..'=' ..v ..'<br>'
	end
	return ret
end

ui:dispatch_get(ui.index, '/')
ui:dispatch_get(ui.route, '/routes/(.+)')
ui:dispatch_get(ui.meta, '/meta')

return ui