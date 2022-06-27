% %% Evaluate Model
% 
% confidenceThreshold = 0.5;
% overlapThreshold = 0.5;
% 
% % Create the test datastore.
% preprocessedTestData = transform(testData, @(data)preprocessData(data, networkInputSize));
% 
% % Create a table to hold the bounding boxes, scores, and labels returned by
% % the detector. 
% numImages = size(testDataTbl, 1);
% results = table('Size', [0 3], ...
%     'VariableTypes', {'cell','cell','cell'}, ...
%     'VariableNames', {'Boxes','Scores','Labels'});
% 
% mbqTest = minibatchqueue(preprocessedTestData, 1, ...
%     "MiniBatchSize", miniBatchSize, ...
%     "MiniBatchFormat", "SSCB");
% 
% % Run detector on images in the test set and collect results.
% while hasdata(mbqTest)
%     % Read the datastore and get the image.
%     XTest = next(mbqTest);
%     
%     % Run the detector.
%     [bboxes, scores, labels] = yolov3Detect(net, XTest, networkOutputs, anchorBoxes, anchorBoxMasks, confidenceThreshold, overlapThreshold, classNames);
%     
%     % Collect the results.
%     tbl = table(bboxes, scores, labels, 'VariableNames', {'Boxes','Scores','Labels'});
%     results = [results; tbl];
% end
% 
% % Evaluate the object detector using Average Precision metric.
% [ap, recall, precision] = evaluateDetectionPrecision(results, preprocessedTestData);
% 
% % Plot precision-recall curve.
% figure
% plot(recall, precision)
% xlabel('Recall')
% ylabel('Precision')
% grid on
% title(sprintf('Average Precision = %.2f', ap));

%% Detect object 

confidenceThreshold = 0.5;
overlapThreshold = 0.5;

% Read the datastore.
% reset(preprocessedTestData)
preprocessedTestData = transform(testData, @(data)preprocessData(data, networkInputSize));
dataDetect = read(preprocessedTestData);

% Get the image.
I = dataDetect{1};

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
    I = insertObjectAnnotation(I, 'rectangle', bboxes{:}, labels{:});
end
figure
imshow(I)
