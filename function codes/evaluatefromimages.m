%% Load the network that is to be evaluated
load('mainnet(0.001_0.0005_0.45)rev4.mat')
load('mAP truth.mat')
%% obtain  images and its box labels from the training images to be compared and evaluated
rng(0);
testDataim = gTruthmAP.DataSource;
testDatabl = gTruthmAP.LabelData;

imdsTest = imageDatastore(testDataim);
bldsTest = boxLabelDatastore(testDatabl);
testData = combine(imdsTest, bldsTest);


results = detect(yolov3Detector,testData);

%% Evaluate the object detector using Average Precision metric.
[ap,recall,precision] = evaluateDetectionPrecision(results,testData);

mAP = mean(ap)
