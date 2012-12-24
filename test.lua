function tt_test()
	local tt=require "margarita.tt"
	local a=tt.table2D{
		{'(1,1)', '(1,2)'},
		{'(2,1)', '(2,2)'}
	}
	print(a:get(1,1))
	print(a:get(1,2))
	print(a:get(2,1))
	print(a:get(2,2))
	print(a:get(1,1,'wrong'))
	print(a:get(3,3,'good'))

	local b=tt.table2D()
	b:set(3,2,'good')
	print(b:get(3,2,'wrong'))
end

function time_test()
	local time=require "margarita.time_utils"
	print(time.to_number("1:10"), (60*60*1)+(10*60))
	print(time.to_number("1:10:10"),(60*60*1)+(60*10)+10)
	local a=time.to_number('3:34:42')
	local b=time.to_parts(a)
	print(b.hh, b.mm, b.ss)
	print(time.to_time(a))
	print(time.add('1:30:25','2:35:45'))
end

function db_test()
	db_utils=require "margarita.db_utils"
	db=db_utils.wrap('szeged2.sqlite')
	--stops=db:get_pairs('SELECT stop_id,stop_name FROM stops')
	stops=db:get_pairs('SELECT agency_id,agency_name FROM agency')
	for k,v in pairs(stops) do
		print(k,v)
	end
	for r in db:rows('SELECT * FROM routes') do
		print(r['route_short_name'])
	end
	print(db_utils.quote("ahoj 'obludo' jak se vede"))
end

db_test()