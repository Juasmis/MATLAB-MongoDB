# Manual to generate dependencies
The idea is to generate a single `.jar` using a dependency manager which will automatically fetch all the required packages.

## Steps
1. Download and install [Maven](https://maven.apache.org/)
2. Generate a `pom.xml` file, see [POM file section](#pom) for more detailed 
information
3. Import dependencies in MATLAB using a function similar to:
	```MATLAB
	function importLibraries()
		% Method used to import the necessary jar files for the libraries used
		
		currentDirectory = pwd;
		librariesDirectory = fullfile(currentDirectory, "lib");
		fileinfo = dir(librariesDirectory);
		if isempty(fileinfo)
			warning('Could not find "lib" folder in %s', librariesDirectory);
		else
			files = {fileinfo.name};
			for i=1:length(files)
				% Filter out dot starting named files and include the 
				% ones containing ".jar" extension 
				if ~strcmp(files{i}(1), '.') && contains(files{i}, ".jar")
					javaaddpath(fullfile( librariesDirectory, files{i} ));
					fprintf('Imported %s to java path\n', files{i});
				end
			end
			% End of for
		end
		% End of method
	end
	```
4. Do not import the classes or method inside MATLAB functions, instead use the
full identifier:
	# Don´t use:
	import com.mongodb.client.MongoClients
	client = MongoClients.create(.....)

	# Instead se:
	client = com.mongodb.client.MongoClients.create(.....)

## POM file <a name="pom"></a>
Generate a pom.xml file with the following structure:

	<?xml version="1.0" encoding="UTF-8"?>
	<project xmlns="http://maven.apache.org/POM/4.0.0"
			 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			 xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
		<modelVersion>4.0.0</modelVersion>
		<groupId>com.psa</groupId>
		<artifactId>medpsa</artifactId>
		<version>1.0.0</version>
		<dependencies>
			<dependency>
			    <groupId>org.mongodb</groupId>
			    <artifactId>bson</artifactId>
			    <version>4.3.3</version>
			</dependency>
			<dependency>
			<groupId>org.mongodb</groupId>
			<artifactId>mongo-java-driver</artifactId>
			<version>3.12.10</version>
			</dependency>
		</dependencies>
		<build>
			<plugins>
			    <plugin>
			        <artifactId>maven-assembly-plugin</artifactId>
			        <configuration>
			        <archive>
			            <manifest>
			            </manifest>
			        </archive>
			        <descriptorRefs>
			            <descriptorRef>jar-with-dependencies</descriptorRef>
			        </descriptorRefs>
			        </configuration>
			    </plugin>
			    </plugins>
	  </build>
	</project>

The important part to update/change is the `dependency` field, use [java lib](https://javalibs.com/)
to find the correct fields for the particular needed library.


## References


1. [POM file structure](https://maven.apache.org/pom.html#Plugin_Repositories)
2. [MATLAB Answers](https://www.mathworks.com/matlabcentral/answers/713843-can-i-load-java-classes-into-matlab-r2020b-using-maven) Can I load Java classes into MATLAB R2020b using Maven? 
3. [javalibs](https://javalibs.com/) Search Public Maven Repositories


