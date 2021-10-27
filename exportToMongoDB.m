function exportToMongoDB(server, port, dbname, colname, exportVar)
    % Method to export an object which inclues a datetime variable
    % to a MongoDB database 
    %
    % Use:
    % toMongoDBDatabase(server, port, dbname, colname, exportVar)
    % server     (string), IP address or hostname of the server hosting the database
    % port       (int),    port used
    % dbname     (string)  name of the database to access
    % colname    (string)  collection name to load the data to
    % exportVar  (struct)  MATLAB object to export to database
    %
    % Neccesary java libraries: jdk8 (java.text.SimpleDateFormat)
    %                           bson (bson.types.*, bson.Dcoument)
    %                           mongdb (mongodb.*)
    
    importLibraries;
    
    % Make sure the time is UTC, generate a warning if it was not
    % the case
    if ~strcmp(exportVar.time.TimeZone, "UTC")
        exportVar.time.TimeZone="UTC";
        warning('TimeZone property was set to "UTC" for field "time"')
    end
    exportVar.time.Format = "dd-MMM-uuuu HH:mm:ss";

    % From MATLAB object to JSON string
    obj_json = jsonencode(exportVar);

    % From JSON string to mongodb object
    obj_json_mongo = org.bson.Document.parse(obj_json);

    % Substitute "time" field for the proper JAVA format
    obj_json_mongo.remove("time");
    
    ft = java.text.SimpleDateFormat("dd-MMM-yyyy HH:mm:ss");
    ft.setTimeZone(java.util.TimeZone.getTimeZone("UTC"));
    time = ft.parse(string( exportVar.time ));

    obj_json_mongo.put("time", time);

    % Establish connection to database using JAVA library and
    % publish new entry

    mongoClient = com.mongodb.client.MongoClients.create(...
        sprintf("mongodb://%s:%s", server, port));
    
    db =  mongoClient.getDatabase(dbname);
    col = db.getCollection(colname);

    col.insertOne(obj_json_mongo);

    fprintf("Operation point exported succesfully to database\n")

end