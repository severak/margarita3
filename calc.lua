#!/usr/bin/env lua
----
-- Time calculator
----
-- part of Margarita3 project
-- (c) Severák 2013
-- License: MIT
----
local timelib=require "margarita.time_utils"

print('Time calculator')

local mem=0

repeat
	cmd=io.read()
	if cmd:match("[%/%*]%d+") then
		local sign, mul = cmd:match("([%/%*])(%d+)")
		if sign=="*" then
			mem=mem*mul
		elseif sign=="/" then
			mem=mem/mul
		end
	elseif cmd:match("[+-]-[%d]+") then
		local sign, add = cmd:match("([+-]-)([:%d]+)")
		local add = timelib.to_number(add)
		if sign=="-" then
			mem=mem-add
		else
			mem=mem+add
		end
	elseif cmd=="=" then
		print(timelib.to_time(mem))
	elseif cmd=="==" then
		print(timelib.to_time(mem))
		print(" ")
		mem=0
	end
until cmd=="x"
