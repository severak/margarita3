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
