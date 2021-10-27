function importLibraries()
    % This function will add to the java path the .jar 
    % library files located inside a lib folder from the
    % current directory
    
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
        