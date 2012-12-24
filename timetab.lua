require 'luasql.sqlite3'
tt=require 'margarita.tt'
env=luasql.sqlite3()
conn=env:connect('szeged2.sqlite')

local route = arg[1] or '1'
local direction = arg[2] or '0'

function rows (connection, sql_statement)
  local cursor = assert (connection:execute (sql_statement))
  local colnames = cursor:getcolnames()
  local tabl = {}
  return function ()
    local data=cursor:fetch(tabl)
    if data then
	local ret={}
	for k,n in pairs(colnames) do
		ret[n]=data[k]
	end
	return ret
    else
      cursor:close()
    end
  end
end

function sequence(conn, sql_statement)
	local cursor = assert (conn:execute (sql_statement))
	local data=cursor:fetch(tabl)
	local ret={}
	while data do
		ret[#ret+1]=data
		data=cursor:fetch()
	end
	cursor:close()
	return ret
end

stops={}
for stop in rows(conn, 'SELECT * FROM stops') do
	stops[ stop['stop_id'] ] = stop['stop_name']
end

trips_sql=[[SELECT DISTINCT st.trip_id FROM stop_times st
JOIN trips t ON st.trip_id=t.trip_id
JOIN routes r ON r.route_id=t.route_id
WHERE t.service_id='MN' AND r.route_short_name='%s' AND direction_id='%s'
ORDER BY arrival_time ASC]]

trips=sequence(conn, string.format(trips_sql, route, direction or 0))
print('trips', table.concat(trips, '#'))

print(trips[1])

stop_ids_sql=[[SELECT stop_id FROM stop_times st
WHERE trip_id='%s'
ORDER BY stop_sequence ASC]]

stop_ids=sequence(conn, string.format(stop_ids_sql, trips[1]))
stop_ord={}
for k,v in pairs(stop_ids) do
	stop_ord[v]=k
end

print('stops', table.concat(stop_ids, ' '))

trip_sql=[[SELECT stop_id, departure_time FROM stop_times st
WHERE trip_id='%s'
ORDER BY stop_sequence ASC]]

sheet=tt.table2D()

for k,v in pairs(stop_ids) do
	sheet:set(k+1, 1, stops[v])
end

for trip_ord,trip_id in pairs(trips) do
	sheet:set(1, trip_ord+1, trip_id)
	for stop_time in rows(conn, string.format(trip_sql, trip_id) ) do
		sheet:set(stop_ord[ stop_time['stop_id'] ]+1 , trip_ord+1, stop_time['departure_time'])
	end
end

sheet:set(1, 1, route)

f=io.open('route.' ..route.. '.' ..direction.. '.html','w')
f:write('<table>')
for r=1, sheet.maxR do
	f:write('<tr>')
	for c=1,sheet.maxC do
		f:write('<td>' .. sheet:get(r,c).. '</td>')
	end
	f:write('</tr>')
end
f:write('</table>')
f:close()


