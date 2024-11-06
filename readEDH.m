function [ret, tUnit, vRange] = readEDH(filename, dataLines)
    %% Set up the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 8);
    
    % Specify range and delimiter
    opts.DataLines = [1, 20];
    opts.Delimiter = " ";

    % Import the data
    ret = readtable(filename, opts);
    tUnit = 1/str2double(table2array(ret(7,4)))*10^-3;    
    vMulti = 0;
    if strcmp(table2array(ret(6,3)), 'pA')
        vMulti = 10^-12;
    elseif strcmp(table2array(ret(6,3)), 'nA')
        vMulti = 10^-9;
    end
    vRange = str2double(table2array(ret(6,2))) * vMulti;
end