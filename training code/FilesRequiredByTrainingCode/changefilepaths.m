%% Run this if DataSource has wrong filepath
% currentPathDataSource is the current path found in the data.gTruth datasource
% newPathDataSource is the path that you want to change it to (the images in your computer)

currentPathDataSource = "C:\Users\Kevin\OneDrive - University of Nottingham Malaysia\Documents\Study\FYP\final\Final YOLOv3 Detector\testing images\Tool_Wear_Data_Images";
newPathDataSource = "C:\Users\Kevin\OneDrive - University of Nottingham Malaysia\Documents\Study\FYP\final\testing images\Tool_Wear_Data_Images";
alternativePaths = {[currentPathDataSource newPathDataSource]};
unresolvedPaths = changeFilePaths(data.gTruth,alternativePaths);

alternativePaths2 = {[currentPathDataSource newPathDataSource]};
unresolvedPaths2 = changeFilePaths(gTruthData,alternativePaths2);

alternativePaths3 = {[currentPathDataSource newPathDataSource]};
unresolvedPaths3 = changeFilePaths(gTruth,alternativePaths2);