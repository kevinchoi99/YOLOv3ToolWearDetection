%% IMPORTANT
% access loadimages.m first and run that before running the training


%% extracting info in the gTruth file
[imds,blds] = objectDetectorTrainingData(gTruthData);

imdsDataSet=imds.Files;
bldsDataSet=blds.LabelData;

combineDataSet=[imdsDataSet bldsDataSet(:,1) bldsDataSet(:,2)];
combineTbl=array2table(combineDataSet);
combineTbl.Properties.VariableNames(1:3) = {'imageFilename','labelData','labelName'};

imdsTrain=imageDatastore(combineTbl.imageFilename);
bldsTrain=boxLabelDatastore(combineTbl(:,2:end));
trainingData=combine(imdsTrain,bldsTrain);

validateInputData(trainingData);


%% Preprocessing - Resizing
networkInputSize = [227 227 3];
preprocessedTrainingData = transform(trainingData, @(data)preprocessData(data, networkInputSize));

%% Augmentation 
% Rotating
augmentedTrainingData1 = transform(preprocessedTrainingData, @testAugment);
% Flipping
augmentedTrainingData2 = transform(augmentedTrainingData1, @augmentData);
num_Data = size(readall(augmentedTrainingData2),1);


%% YOLOv3 Network

rng(1)
trainingDataForEstimation = transform(trainingData, @(data)preprocessData(data, networkInputSize));
% number of anchor boxes
numAnchors = 4;
[anchors, meanIoU] = estimateAnchorBoxes(trainingDataForEstimation, numAnchors);

area = anchors(:, 1).*anchors(:, 2);
[~, idx] = sort(area, 'descend');
anchors = anchors(idx, :);
anchorBoxes = {anchors(1:2,:)
    anchors(3:4,:)
    };

classNames = {'flank_wear','notch_wear','chipping','flaking','bue'};
numClasses = size(classNames, 2);

% creating yolov3ObjectDetector
baseNetwork=squeezenet;

yolov3Detector = yolov3ObjectDetector(baseNetwork,classNames,anchorBoxes,'DetectionNetworkSource',{'fire9-concat', 'fire5-concat'});





%% traning options
numEpochs = 80;
miniBatchSize = 16; %32
learningRate = 0.001; %0.0001
warmupPeriod = 1000;
l2Regularization = 0.0005;
penaltyThreshold = 0.6;
velocity = [];
 
%% Train Model
doTraining = true;
if canUseParallelPool
   dispatchInBackground = true;
else
   dispatchInBackground = false;
end
mbqTrain = minibatchqueue(preprocessedTrainingData, 2,...
        "MiniBatchSize", miniBatchSize,...
        "MiniBatchFcn", @(images, boxes, labels) createBatchData(images, boxes, labels, classNames), ...
        "MiniBatchFormat", ["SSCB", ""],...
        "DispatchInBackground", dispatchInBackground,...
        "OutputCast", ["", "double"]);
if doTraining
    
    % Create subplots for the learning rate and mini-batch loss.
    fig = figure;
    [lossPlotter, learningRatePlotter] = configureTrainingProgressPlotter(fig);
    iteration = 0;
    % Custom training loop.
    for epoch = 1:numEpochs
          
        reset(mbqTrain);
        shuffle(mbqTrain);
        
        while(hasdata(mbqTrain))
            iteration = iteration + 1;
           
            [XTrain, YTrain] = next(mbqTrain);
            
            % Evaluate the model gradients and loss using dlfeval and the
            % modelGradients function.
            [gradients, state, lossInfo] = dlfeval(@modelGradients, yolov3Detector, XTrain, YTrain, penaltyThreshold);
    
            % Apply L2 regularization.
            gradients = dlupdate(@(g,w) g + l2Regularization*w, gradients, yolov3Detector.Learnables);
    
            % Determine the current learning rate value.
            currentLR = piecewiseLearningRateWithWarmup(iteration, epoch, learningRate, warmupPeriod, numEpochs);
    
            % Update the detector learnable parameters using the SGDM optimizer.
            [yolov3Detector.Learnables, velocity] = sgdmupdate(yolov3Detector.Learnables, gradients, velocity, currentLR);
    
            % Update the state parameters of dlnetwork.
            yolov3Detector.State = state;
              
            % Display progress.
            displayLossInfo(epoch, iteration, currentLR, lossInfo);  
                
            % Update training plot with new points.
            updatePlots(lossPlotter, learningRatePlotter, iteration, currentLR, lossInfo.totalLoss);
        end        
    end
end


confidenceThreshold = 0.6;
overlapThreshold = 0.6;


