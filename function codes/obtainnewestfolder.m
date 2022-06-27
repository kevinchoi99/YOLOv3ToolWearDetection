%%script to obtain newest folder in a folder
d = dir(cameradestination);
d = d(~ismember({d.name},{'.','..'}));
% find the last modified file
[~,idx] = max([d.datenum]);
% name of file
folder_name = d(idx).name;
image_folder = fullfile(cameradestination,folder_name);