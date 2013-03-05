----
-- Model
----
-- part of Margarita3 project
-- (c) Severák 2012
-- License: MIT
----
local _M={}
local Date=require "pl.Date"

_M.route_type={
	[0]='TRAM',
	[1]='METRO',
	[2]='VLAK',
	[3]='BUS',
	[4]='TRAJEKT',
	[5]='CABLE CAR',
	[6]='LANOVKA',
	[7]='POZEMNI LANOVKA'
}

_M.direction={
	[0]='po',
	[1]='proti'
}

_M.pickup_type={
	[0]='pravidelna',
	[1]='nezastavuje',
	[2]='objednavka telefonem',
	[3]='zastavka na znameni',
}

_M.service_exception_type={
	ADDED=1,
	REMOVED=2
}

-- index starts at 1, welcome to Lua :-D
_M.day_names={'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'}

_M.dropoff_type=_M.pickup_type

_M.schema=[[
CREATE TABLE "agency" ("agency_id"  PRIMARY KEY  NOT NULL , "agency_name" TEXT NOT NULL, "agency_url" , "agency_timezone" , "agency_phone" , "agency_lang" );
CREATE TABLE "calendar" ("service_id"  PRIMARY KEY  NOT NULL , "monday" , "tuesday" , "wednesday" , "thursday" , "friday" , "saturday" , "sunday" , "start_date" DATE, "end_date" DATE);
CREATE TABLE "calendar_dates" ("service_id"  PRIMARY KEY  NOT NULL , "date" , "exception_type" );
CREATE TABLE "margarita_meta" ("key" TEXT PRIMARY KEY  NOT NULL , "val" TEXT);
CREATE TABLE "routes" ("route_id"  PRIMARY KEY  NOT NULL , "agency_id" , "route_short_name" , "route_long_name" , "route_desc" , "route_type" , "route_url" , "route_color" , "route_text_color" );
CREATE TABLE "stop_times" ("trip_id" ,"arrival_time" ,"departure_time" ,"stop_id" ,"stop_sequence" INTEGER, "pickup_type" INTEGER DEFAULT 0,"drop_off_type" INTEGER DEFAULT 0);
CREATE TABLE "stops" ("stop_id"  PRIMARY KEY  NOT NULL , "stop_name" , "stop_lat" , "stop_lon" , "wheelchair_boarding" BOOL DEFAULT 0);
CREATE TABLE "template_times" ("template_id","arrival_time" INTEGER, "departure_time" INTEGER , "stop_id", "stop_sequence" INT, "pickup_type" INTEGER DEFAULT 0, "drop_off_type" INTEGER DEFAULT 0);
CREATE TABLE "templates" ("template_id" PRIMARY KEY, "route_id" ,"service_id" ,"trip_headsign" ,"direction_id" BOOL,"shape_id" );
CREATE TABLE "trips" ("trip_id"  PRIMARY KEY  NOT NULL , "route_id" , "service_id" , "trip_headsign" , "direction_id" BOOL, "shape_id" );

INSERT INTO margarita_meta VALUES('margarita_major',3);
INSERT INTO margarita_meta VALUES('margarita_minor',1);
]]

_M.check_db=function(db_wrap)
	local db_cfg=db_wrap:get_pairs('SELECT key,val FROM margarita_meta')
	if tonumber(db_cfg.margarita_major)==margarita.version.major and tonumber(db_cfg.margarita_minor)<=margarita.version.minor then
		return true
	else
		return nil, 'Spatna verze databaze!'
	end
end

function _M.valid_services(db_wrap, orig_date)
	local ymd = Date.Format('yyyy-mm-dd')
	local date = Date(orig_date)
	local day_name = _M.day_names[ date.tab.wday ]
	local query = string.format(
		'SELECT service_id,1 FROM calendar WHERE start_date<="%s" AND end_date>="%s" AND %s=1',
		ymd:tostring(date),
		ymd:tostring(date),
		day_name);
	local services = db_wrap:get_pairs(query)
	local exceptions_query = string.format('SELECT * FROM calendar_dates WHERE date="%s"', ymd:tostring(date) )
	for exc in db_wrap:rows(exceptions_query) do
		if exc.exception_type == _M.service_exception_type.ADDED then
			services[ exc.service_id ] = 1
		elseif exc.exception_type == _M.service_exception_type.REMOVED then
			services[ exc.service_id ] = nil
		end
	end
	return services
end

return _M