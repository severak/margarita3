----
-- Table top library
----
-- part of Margarita3 project
-- (c) Severák 2012
-- License: MIT
----

local tt_proto={
	maxR = 0,
	maxC = 0,

	get = function(self, r, c, default)
		default = default or ''
		local row = self[r] or {}
		return row[c] or default
	end,
	
	set = function(self, r, c, value)
		self[r] = self[r] or {}
		self[r][c] = value
		if r>self.maxR then self.maxR=r end
		if c>self.maxC then self.maxC=c end
	end
}

return {
	table2D = function(t)
		t = t or {}
		setmetatable(t, {__index=tt_proto})
		return t
	end
}