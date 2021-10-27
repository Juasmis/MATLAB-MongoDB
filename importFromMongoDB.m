function datos = importFromMongoDB(server, port, dbname, colname)
    % Method to import data from a MongoDB database. 
    %
    % Use:
    % datos = importFromDatabase(server, port, dbname, colname)
    %  
    % server     (string), IP address or hostname of the server hosting the database
    % port       (int),    port used
    % dbname     (string)  name of the database to access
    % colname    (string)  collection name to retrieve data from

    importLibraries;
    
    mongoClient = com.mongodb.client.MongoClients.create(...
        sprintf("mongodb://%s:%s", server, port));
    
    db =  mongoClient.getDatabase(dbname);
    col = db.getCollection(colname);
    
    cursor = col.find().iterator();
    i=1;
    try 
        while (cursor.hasNext()) 
            data_json = string( cursor.next().toJson() );
            data = jsondecode(data_json);
            data.time = datetime(...
                data.time.x_date, ...
                InputFormat = "uuuu-MM-dd'T'HH:mm:ss.SSS'Z'", ...
                Timezone = "UTC" );
            
            % With Atlas a field x_id gets added, erase it from the data retrieved
            if sum(strcmp(fieldnames(data), 'x_id')) == 1
                data = rmfield(data,"x_id"); 
            end
            
            datos(i) = data;
            i=i+1;
        end
    catch MException
        cursor.close();
        disp(MException)
    end
    
    datos = table2timetable( struct2table(datos) );
end
