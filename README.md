# MATLAB-MongoDB
A more complete integration to import and export data from MATLAB to a Mongo database. Mainly support for datetimes.

### Limitations of current official implementation
The official Mongodb support ([documentation](https://www.mathworks.com/help/database/ug/import-and-export-matlab-objects-using-mongodb.html)) has an important limitation, MATLAB datetimes objects are not compatible with BSON dates. This means that exported MATLAB datetimes variables to the database will be formatted as string. Date type variables imported from the database will appear as string variables in the MATLAB workspace as well. This second situation can easily be solved with a code similar to:
```MATLAB
    timeStamp = datetime(dataFromDatabase.timeStamp, InputFormat = "uuuu-MM-dd'T'HH:mm:ss.SSS'Z'", Timezone  );
```
The first one is not so trivial as it makes impossible to interact with TimeSeries mongoDB collections as well as limiting the time filtered queries on normal collections.

### Proposed alternative
One alternative could be to access every new *document* inserted in the database and update it's `Date` field using MongoDB functions such as [updateOne](https://docs.mongodb.com/manual/reference/method/db.collection.updateOne/#mongodb-method-db.collection.updateOne), [updateMany](https://docs.mongodb.com/manual/reference/method/db.collection.updateMany/#mongodb-method-db.collection.updateMany) and [replaceOne](https://docs.mongodb.com/manual/reference/method/db.collection.replaceOne/#mongodb-method-db.collection.replaceOne). 

A cleaner solution seems to export directly the data from MATLAB. With this porpuse, [MATLAB's ability to make use of JAVA libraries](https://www.mathworks.com/help/matlab/matlab-engine-api-for-java.html) will be taken advantage of.  
###

### References
