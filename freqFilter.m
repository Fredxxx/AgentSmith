function dataCO = freqFilter(data, lowFr, highFr, tUnit)
    disp(lowFr)
    disp(highFr)
    disp(tUnit)
    dataCO = data;
    dataCO(1,:) = lowpass(data(1,:),highFr*1000, 1/tUnit);
    dataCO(2,:) = lowpass(data(2,:),highFr*1000, 1/tUnit);
    dataCO(3,:) = lowpass(data(3,:),highFr*1000, 1/tUnit);
    dataCO(4,:) = lowpass(data(4,:),highFr*1000, 1/tUnit);
    if lowFr ~= 0
        dataCO(1,:) = highpass(dataCO(1,:),lowFr*1000, 1/tUnit);
        dataCO(2,:) = highpass(dataCO(2,:),lowFr*1000, 1/tUnit);
        dataCO(3,:) = highpass(dataCO(3,:),lowFr*1000, 1/tUnit);
        dataCO(4,:) = highpass(dataCO(4,:),lowFr*1000, 1/tUnit);
    end
end