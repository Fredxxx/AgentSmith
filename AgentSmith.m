clearvars
close all
%% new version
testMode = false; 
dirtyFlag = false;

% get file paths
if testMode
    paths.pathDat = 'C:\UlbrichFred\nEOdiag\Data\20250305_ctxCy3\09_ch4_15pF_75nM_100ms_600frames_100um_2mW_01kHz_2nA\test_2\';
    paths.edh = 'test.edh';
    paths.dat = 'test_000.dat';
    paths.pathImg = 'C:\UlbrichFred\nEOdiag\Data\20250305_ctxCy3\09_ch4_15pF_75nM_100ms_600frames_100um_2mW_01kHz_2nA\';
    paths.img = '09_ch4_15pF_75nM_100ms_600frames_100um_2mW_01kHz_2nA_MMStack_Default.ome.tif';
else
    path = "C:\UlbrichFred\nEOdiag\Data\20250305_ctxCy3";      % data to load
    paths = pathFinder(path);
end

% read meta data from edh
[meta] = readEDH([paths.pathDat paths.edh]);

% load EDR4 data
[data, tDat, tImg] = loadED4data(paths, meta);

% scale Data 
[dataSc] = scaleData(data);

% load image
pathImg = [paths.pathImg paths.img];
rawImg = double(tiffreadVolume(pathImg));

% dirty fix to ensure same lenght for tImg and img z dimesnion
s = size(rawImg);
l = length(tImg);
if l > s(3)
    tImg = tImg(1:end-(l-s(3)));
    dirtyFlag = true;
elseif l < s(3)
    tImg(l:s(3)) = tImg(l);
    dirtyFlag = true;
end

%%
figDat = figure;
ax2 = axes(figDat); % Get the axes handle
plot(tDat, dataSc(2,:), tDat, dataSc(1,:), tDat, dataSc(3,:), tImg, zeros(1,length(tImg))); 
xlabel('[s]')
ylabel({'[nA]', '[100mV]'})
frate = 1/meta.tUnit/1000;
title([sprintf('sampling rate %.2f kHz, voltage range %.0e A \n', frate, meta.vRange) meta.acqDateStr])
legend({'Trigger', 'Data', 'Voltage', 'intensity'}, 'Location', 'best')
hold off


%%
figImg = figure;
imshow(rawImg(:,:,300), []);  % Adjusts the intensity scale to fit the data
% Create a rectangular ROI
roi = drawcircle('Label', 'ROI', 'Color', 'r');  % Create the ROI and label it 'ROI'

figDat = figure;
ax2 = axes(figDat); % Get the axes handle
plot(tDat, dataSc(1,:), tDat, dataSc(3,:), tImg, zeros(1,length(tImg)));
%plot(tDat, dataSc(2,:), tDat, dataSc(1,:), tDat, dataSc(3,:), tImg, zeros(1,length(tImg))); 
xlabel('[s]')
ylabel({'[nA]', '[100mV]'})
frate = 1/meta.tUnit/1000;
titleStr = [sprintf('sampling rate %.2f kHz, voltage range %.0e A \n', frate, meta.vRange) meta.acqDateStr];
title(titleStr)
legend({'Data', 'Voltage', 'intensity'}, 'Location', 'best')
%legend({'Trigger', 'Data', 'Voltage', 'intensity'}, 'Location', 'best')

addlistener(roi, 'MovingROI', @(src, event) updatePosition(src, rawImg, ax2, dataSc, tDat, tImg, titleStr));
% Callback function to update the position
function updatePosition(roi, img, ax2, dataSc, tDat, tImg, titleStr)
    pause(0.1)
    % Get the position of the ROI (bounding box)
    position = roi.Position;  % [x_center, y_center, radius]
    x_center = round(position(1));  % X-coordinate of the center
    y_center = round(position(2));  % Y-coordinate of the center
    radius = roi.Radius;            % Radius of the circle

    % Create a mask for the circular ROI
    [x, y] = meshgrid(1:size(img(:,:,300), 2), 1:size(img(:,:,300), 1));  % Create a grid of coordinates
    mask = (x - x_center).^2 + (y - y_center).^2 <= radius^2;  % Create circular mask

    % Extract the data inside the circular ROI using the mask
    roiData = img.*mask;  % Apply the mask to extract the data inside the circle
    intMax = squeeze(max(max(roiData(:,:,:))));
    intMean = squeeze(sum(sum(roiData(:,:,:))))/nnz(roiData(:,:,300));
    intPlot = intMean/1000;
    figure(ax2.Parent);
    %plot(tDat, dataSc(2,:), tDat, dataSc(1,:), tDat, dataSc(3,:), tImg, intPlot);
    plot(tDat, dataSc(1,:), tDat, dataSc(3,:), tImg, intPlot);
    title(ax2, titleStr)
    xlabel(ax2, '[s]')
    ylabel(ax2, {'current [nA]', 'voltage [100mV]', 'intensity [1000]'})
    legend(ax2, {'Ch4', 'Voltage', 'intensity'}, 'Location', 'best')
    %legend(ax2, {'Trigger', 'Data', 'Voltage', 'intensity'}, 'Location', 'best')
end