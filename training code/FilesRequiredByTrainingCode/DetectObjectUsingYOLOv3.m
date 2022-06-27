%========================================================================
%detect objects using YOLO v3
% Read the datastore.
reset(preprocessedTestData);
% data = read(preprocessedTestData);

data = imread('test.jpg');
TestDataset = data.TestDataset;
TestDataset.imageFilename = fullfile(pwd, TestDataset.imageFilename);
testDataTbl = TestDataset;
imdsTest = imageDatastore(testDataTbl.imageFilename);
bldsTest = boxLabelDatastore(testDataTbl(:, 2:end));
testData = combine(imdsTest, bldsTest);
validateInputData(testData);
preprocessedTestData = transform(testData, @(data)preprocessData(data, networkInputSize));
data = read(preprocessedTestData);

% Get the image.
I = data{1};

% Convert to dlarray.
XTest = dlarray(I, 'SSCB');

executionEnvironment = "auto";

% If GPU is available, then convert data to gpuArray.
if (executionEnvironment == "auto" && canUseGPU) || executionEnvironment == "gpu"
    XTest = gpuArray(XTest);
end

[bboxes, scores, labels] = yolov3Detect(net, XTest, networkOutputs, anchorBoxes, anchorBoxMasks, confidenceThreshold, overlapThreshold, classNames);

% Clear the persistent variables used in the yolov3Detect function to avoid retaining their values in memory.
clear yolov3Detect  

% Display the detections on image.
if ~isempty(scores{1})
    I = insertObjectAnnotation(I, 'rectangle', bboxes{1}, scores{1});
end
figure
imshow(I)