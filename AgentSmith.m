clearvars
close all
%% new version
close all
testMode = true; 

% get file paths
if testMode
    paths.pathDat = 'C:\UlbrichFred\nEOdiag\Data\20250305_ctxCy3\09_ch4_15pF_75nM_100ms_600frames_100um_2mW_01kHz_2nA\test_2\';
    paths.edh = 'test.edh';
    paths.dat = 'test_000.dat';
    paths.pathImg = 'C:\UlbrichFred\nEOdiag\Data\20250305_ctxCy3\09_ch4_15pF_75nM_100ms_600frames_100um_2mW_01kHz_2nA\';
    paths.img = '09_ch4_15pF_75nM_100ms_600frames_100um_2mW_01kHz_2nA_MMStack_Default.ome.tif';
else
    path = "C:\UlbrichFred\nEOdiag\Data\20250305_ctxCy3\09_ch4_15pF_75nM_100ms_600frames_100um_2mW_01kHz_2nA";      % data to load
    paths = pathFinder(path);
end

% read meta data from edh
[meta] = readEDH([paths.pathDat paths.edh]);

% load EDR4 data
[data, tDat, tImg] = loadED4data(paths, meta);

% scale Data 
[dataSc] = scaleData(data);

%%
figDat = figure;
ax2 = axes(figDat); % Get the axes handle
plot(tDat, dataSc(2,:)); 
hold on
plot(tDat, dataSc(1,:)); 
hold on
plot(tDat, dataSc(3,:)); 
hold on
plot(tImg, zeros(1,length(tImg))); 
xlabel('[s]')
ylabel({'[nA]', '[100mV]'})
frate = 1/meta.tUnit/1000;
title([sprintf('sampling rate %.2f kHz, voltage range %.0e A \n', frate, meta.vRange) meta.acqDateStr])
legend({'Trigger', 'Data', 'Voltage', 'intensity'}, 'Location', 'best')
hold off
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

%% load image
pathImg = [paths.pathImg paths.img];
rawImg = double(tiffreadVolume(pathImg));
%%
figImg = figure;
imshow(rawImg(:,:,300), []);  % Adjusts the intensity scale to fit the data
% Create a rectangular ROI
roi = drawcircle('Label', 'ROI', 'Color', 'r');  % Create the ROI and label it 'ROI'

figDat = figure;
ax2 = axes(figDat); % Get the axes handle
plot(tDat, dataSc(2,:), tDat, dataSc(1,:), tDat, dataSc(3,:), tImg, zeros(1,length(tImg))); 
xlabel('[s]')
ylabel({'[nA]', '[100mV]'})
frate = 1/meta.tUnit/1000;
titleStr = [sprintf('sampling rate %.2f kHz, voltage range %.0e A \n', frate, meta.vRange) meta.acqDateStr];
title(titleStr)
legend({'Trigger', 'Data', 'Voltage', 'intensity'}, 'Location', 'best')
hold off

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
    plot(tDat, dataSc(2,:), tDat, dataSc(1,:), tDat, dataSc(3,:), tImg, intPlot);
    title(ax2, titleStr)
    legend(ax2, {'Trigger', 'Data', 'Voltage', 'intensity'}, 'Location', 'best')
end

intDat = squeeze(max(max(rawData1(1:16,1:16, :))));
intDatMean = squeeze(mean(mean(rawData1(1:16,1:16, :))));


%% start imageJ
%Miji;
%% define stuff

path = "C:\UlbrichFred\nEOdiag\Data\20250305_ctxCy3\09_ch4_15pF_75nM_100ms_600frames_100um_2mW_01kHz_2nA";      % data to load
paths = pathFinder(path);
trigger = 1; % 1 = device has trigger channel, 0 = device does not have trigger channel
dt = 0.01;                  % signal edge addon [s]
%% load meta data
pathSplit = strsplit(path, "\");
pathMeta = path + "\" + "test.edh";
fidMeta = fopen(pathMeta, "rb");
[meta] = readEDH(pathMeta);
chNum = length(activeCh) + 1;                % number of channels to be read

% %% load data
% 
% data = loadED4data()
% pathDat = path + "\" + "test_000.dat";
% 
% fidDat = fopen(pathDat, "rb");
% d = fread(fidDat, inf, "single");
% data(1,:) = d(1:chNum:end);
% data(2,:) = d(2:chNum:end);
% data(3,:) = d(3:chNum:end);
% % data(4,:) = d(4:chNum:end);
% % data(5,:) = d(5:chNum:end);
% % data(6,:) = d(6:chNum:end);
% t = (1:length(data))*tUnit;
% 
% % %dirty only for me -> simulate trigger for 10 images 
% % zeroD = find(data(5,:)<0);
% % dd = zeros(1, length(data));
% % dd(zeroD(15:24))= -0.0061;
% 
% %% load images
% pathImg = "C:\UlbrichFred\nEOdiag\Data\20250305_ctxCy3\09_ch4_15pF_75nM_100ms_600frames_100um_2mW_01kHz_2nA\09_ch4_15pF_75nM_100ms_600frames_100um_2mW_01kHz_2nA_MMStack_Default.ome.tif";
% rawData1 = tiffreadVolume(pathImg);
% %MIJ.createImage('pathImg', rawData1, true);
% intDat = squeeze(max(max(rawData1(1:16,1:16, :))));
% intDatMean = squeeze(mean(mean(rawData1(1:16,1:16, :))));
% %% find signals
% %xLimStart = 178.65e3;
% %xLimEnd = 179.2e3;
% xTrigs = find(dataSc(5,:))*tUnit;
% xTrigMin = xTrigs(1)-dt;
% xTrigMax = xTrigs(end)*2-xTrigs(end-1)+dt;
% xVolMin = find(data(6,:),1,'first')*tUnit-dt;
% xVolMax = find(data(6,:),1,'last')*tUnit+dt;
% xSmartMin = min(xTrigMin, xVolMin);
% xSmartMax = max(xTrigMin, xVolMin);
% %% scale data to 1
% dataSc(1,:) = data(1,:)/max(max(data(1,:),abs(min(data(1,:)))));
% dataSc(2,:) = data(2,:)/max(max(data(2,:),abs(min(data(2,:)))));
% dataSc(3,:) = data(3,:)/max(max(data(3,:),abs(min(data(3,:)))));
% dataSc(4,:) = data(4,:)/max(max(data(4,:),abs(min(data(4,:)))));
% dataSc(5,:) = data(5,:)/max(max(data(5,:),abs(min(data(5,:)))));
% dataSc(6,:) = data(6,:)/max(max(data(6,:),abs(min(data(6,:)))));
% %ddSc = dd/max(max(dd,abs(min(dd))));
% intDatMeanSc = intDatMean/max(max(intDatMean,abs(min(intDatMean))));
% %% plot stuff
% close all
% figure
% plot(t, dataSc(1,:)), hold on
% plot(t, dataSc(2,:)), hold on
% plot(t, dataSc(3,:)), hold on
% %plot(t, dataSc(4,:))
% legend('DataCh1', 'DataCh2', 'DataCh3', 'DataCh4')
% %xlim([xTrigMin, xTrigMax])
% 
% %%
% figure
% plot(t, data(6,:)), hold on
% plot(t, abs(dd*max(data(6,:)*250/3))), hold on
% plot(xTrigs, intDatMean)
% legend('Voltage Pulse', 'Trigger', 'IntImg')
% %xlim([3.572, 3.586])
% %xlim([xTrigMin, xTrigMax])
% %%
% figure
% plot(t, dataSc(6,:)), hold on
% plot(t, abs(dataSc(2,:))), hold on
% plot(xTrigs, intDatMeanSc)
% legend('Voltage Pulse', 'Trigger', 'IntImg')
% %xlim([3.572, 3.586])
% %xlim([xTrigMin, xTrigMax])