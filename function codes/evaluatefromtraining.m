%% Load the network that is to be evaluated
load('mainnet(0.001_0.0005_0.45)rev3.mat')

%% obtain random images and its box labels from the training images to be compared and evaluated
rng(0);
shuffledIndices = randperm(height(gTruthData.DataSource.Source));
idxtest = floor(0.6 * length(shuffledIndices));
testDataim = data.gTruth.DataSource.Source(shuffledIndices(idxtest+1:end), :);
testDatabl = data.gTruth.LabelData(shuffledIndices(idxtest+1:end),:);

imdsTest = imageDatastore(testDataim);
bldsTest = boxLabelDatastore(testDatabl);
testData = combine(imdsTest, bldsTest);


results = detect(yolov3Detector,testData,'MiniBatchSize',8);

%% Evaluate the object detector using Average Precision metric.
[ap,recall,precision] = evaluateDetectionPrecision(results,testData);

figure
plot(recall{1,1},precision{1,1})
hold on
plot(recall{2,1},precision{2,1})
plot(recall{3,1},precision{3,1})
plot(recall{4,1},precision{4,1})
plot(recall{5,1},precision{5,1})
xlabel('Recall')
ylabel('Precision')
legend('UniformFlankWear','Chipping','Notching','BUE','Flaking')
grid on
title('P-R Curve')

mAP = mean(ap)
