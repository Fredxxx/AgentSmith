clearvars
close all
%% start imageJ
addpath('C:\FIJI\Fiji.app\scripts')
javaaddpath 'C:\Program Files\MATLAB\R2024b\java\mij.jar'
Miji;
%% define stuff
path = "C:\UlbrichFred\nEOdiag\matlab\TestData\test";      % data to load
chNum = 6;                  % number of channels to be read
dt = 0.01;                  % signal edge addon [s]
%% load meta data
pathSplit = strsplit(path, "\");
pathMeta = path + "\" + pathSplit(end) + ".edh";
fidMeta = fopen(pathMeta, "rb");
[dMeta, tUnit, vRange] = readEDH(pathMeta);

%% load data
pathDat = path + "\" + pathSplit(end) + "_000.dat";

fidDat = fopen(pathDat, "rb");
d = fread(fidDat, inf, "single");
data(1,:) = d(1:chNum:end);
data(2,:) = d(2:chNum:end);
data(3,:) = d(3:chNum:end);
data(4,:) = d(4:chNum:end);
data(5,:) = d(5:chNum:end);
data(6,:) = d(6:chNum:end);
t = (1:length(data))*tUnit;

%dirty only for me -> simulate trigger for 10 images 
zeroD = find(data(5,:)<0);
dd = zeros(1, length(data));
dd(zeroD(15:24))= -0.0061;

%% load images
pathImg = path + "\z_stack1.ome.tif";
rawData1 = tiffreadVolume(pathImg);
MIJ.createImage('pathImg', rawData1, true);
intDat = squeeze(max(max(rawData1(1:16,1:16, :))));
intDatMean = squeeze(mean(mean(rawData1(1:16,1:16, :))));
%% find signals
%xLimStart = 178.65e3;
%xLimEnd = 179.2e3;
xTrigs = find(dd)*tUnit;
xTrigMin = xTrigs(1)-dt;
xTrigMax = xTrigs(end)*2-xTrigs(end-1)+dt;
xVolMin = find(data(6,:),1,'first')*tUnit-dt;
xVolMax = find(data(6,:),1,'last')*tUnit+dt;
xSmartMin = min(xTrigMin, xVolMin);
xSmartMax = max(xTrigMin, xVolMin);
%% scale data to 1
dataSc(1,:) = data(1,:)/max(max(data(1,:),abs(min(data(1,:)))));
dataSc(2,:) = data(2,:)/max(max(data(2,:),abs(min(data(2,:)))));
dataSc(3,:) = data(3,:)/max(max(data(3,:),abs(min(data(3,:)))));
dataSc(4,:) = data(4,:)/max(max(data(4,:),abs(min(data(4,:)))));
dataSc(5,:) = data(5,:)/max(max(data(5,:),abs(min(data(5,:)))));
dataSc(6,:) = data(6,:)/max(max(data(6,:),abs(min(data(6,:)))));
ddSc = dd/max(max(dd,abs(min(dd))));
intDatMeanSc = intDatMean/max(max(intDatMean,abs(min(intDatMean))));
%% plot stuff
close all
% figure
% plot(t, data(1,:)), hold on
% plot(t, data(2,:)), hold on
% plot(t, data(3,:)), hold on
% plot(t, data(4,:))
% legend('DataCh1', 'DataCh2', 'DataCh3', 'DataCh4')
% xlim([xTrigMin, xTrigMax])
figure
plot(t, data(6,:)), hold on
plot(t, abs(dd*max(data(6,:)*250/3))), hold on
plot(xTrigs, intDatMean)
legend('Voltage Pulse', 'Trigger', 'IntImg')
%xlim([3.572, 3.586])
xlim([xTrigMin, xTrigMax])

figure
plot(t, dataSc(6,:)), hold on
plot(t, abs(ddSc)), hold on
plot(xTrigs, intDatMeanSc)
legend('Voltage Pulse', 'Trigger', 'IntImg')
%xlim([3.572, 3.586])
xlim([xTrigMin, xTrigMax])