function [paths] = pathFinder(pathStart)
    
    [file1, path1] = uigetfile('*.edh', 'Select EDR4 data (.edh) file', pathStart);
    % check if selected
    if isequal(file1, 0)
        disp('User selected Cancel');
    else
        disp(['User selected ', fullfile(path1, file1)]);
    end

    [file2, path2] = uigetfile('*.tif', 'Select image sequence (.tif) file', pathStart);
    % check if selected
    if isequal(file2, 0)
        disp('User selected Cancel');
    else
        disp(['User selected ', fullfile(path2, file2)]);
    end
    paths.pathDat = path1;
    paths.edh = file1;
    paths.dat = [paths.edh(1:end-4) '_000.dat'];
    paths.pathImg = path2;
    paths.img = file2;

end