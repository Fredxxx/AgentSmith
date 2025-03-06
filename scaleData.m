function [dataSc] = scaleData(data)
    s = size(data);
    dataSc = data;
    for i = 1:s(1)-2
        dataSc(i,:) = data(i, :);
    end
    dataSc(end-1, :) = data(end-1,:)/max(data(end-1,:)) * max(max((data(1:end-2,:))))/2;
    dataSc(end, :) = data(end,:)/100;
end