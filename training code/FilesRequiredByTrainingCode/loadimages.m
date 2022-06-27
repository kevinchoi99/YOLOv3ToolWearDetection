%% load the .mat file
% load groundTruth data
data=load('Tool_Wear_Image_data_rev4.mat');
gTruthData=data.gTruth;

% if Warning appears, run changefilepaths.m
% do not run this again after running changefilepaths.m
