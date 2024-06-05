function path = explorerFileName()
[file,location] = uigetfile('D:\Fred\nEOdiag\matlab\*.dat', 'Please choose the .dat file to load!');
if isequal(file,0)
   disp('User selected Cancel');
   path = -1;
else
   disp(['User selected ', fullfile(location,file)]);
   path = fullfile(location,file);
end