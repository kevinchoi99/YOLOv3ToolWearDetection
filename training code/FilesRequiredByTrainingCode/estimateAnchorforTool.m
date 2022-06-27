data=load('toolwearsGroundTruth.mat');
gTruthData=data.gTruth;

[imds,blds] = objectDetectorTrainingData(gTruthData);

imdsDataSet=imds.Files;
bldsDataSet=blds.LabelData;

combineDataSet=[imdsDataSet bldsDataSet(:,1) bldsDataSet(:,2)];
combineTbl=array2table(combineDataSet);
combineTbl.Properties.VariableNames(1:3) = {'imageFilename','labelData','labelName'};

trainingData=boxLabelDatastore(combineTbl(:,2:end));
numAnchors=12;
[anchorBoxes,meanIoU] = estimateAnchorBoxes(trainingData,numAnchors);