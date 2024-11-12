addpath('C:\FIJI\Fiji.app\scripts')
javaaddpath 'C:\Program Files\MATLAB\R2024b\java\mij.jar'

Miji;
path = "C:\UlbrichFred\nEOdiag\matlab\TestData\test";
pathImg = path + "\z_stack1.ome.tif";
rawData1 = tiffreadVolume(pathImg);
MIJ.createImage('stacky', rawData1, true);
