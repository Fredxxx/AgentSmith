function [data, tDat, tImg] = loadED4data(paths, meta)
        
    fidDat = fopen([paths.pathDat paths.dat], "rb");
    d = fread(fidDat, inf, "single");
    numCh = meta.numOfCh + 1;
    lDat = length(d)/numCh;
    data = zeros(numCh, lDat);
    for i = 1:numCh
        data(i,:) = d(i:numCh:end);
    end    
    tDat = (1:length(data))*meta.tUnit;
    tImg = find(data(numCh-1,:))*meta.tUnit;
end