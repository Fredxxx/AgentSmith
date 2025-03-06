function [meta] = readEDH(filename)
    %% Set up the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 8);
    
    % Specify range and delimiter
    opts.DataLines = [1, 20];
    opts.Delimiter = " ";

    % Import the data
    metaRaw = readtable(filename, opts);
    meta.tUnit = 1/str2double(table2array(metaRaw(7,4)))*10^-3;    
    vMulti = 0;
    if strcmp(table2array(metaRaw(6,3)), 'pA')
        vMulti = 10^-12;
    elseif strcmp(table2array(metaRaw(6,3)), 'nA')
        vMulti = 10^-9;
    end
    meta.vRange = str2double(table2array(metaRaw(6,2))) * vMulti;
    meta.vUnit = vMulti;
    activeCh = str2double(table2array(metaRaw(10,:)));
    meta.activeCh = activeCh(~isnan(activeCh));
    meta.numOfCh = length(meta.activeCh);
    meta.metaRaw = metaRaw;
end