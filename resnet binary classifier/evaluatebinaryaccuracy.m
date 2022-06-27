%% loading image from main folder
outputFolder = fullfile('ResNet50_Data2');
load("trainedResNet3.mat")

% loading images from categories
categories = {'WearInsertstest','Residuestest'};
imds = imageDatastore(fullfile(outputFolder,categories), 'LabelSource', 'foldernames');
tbl = countEachLabel(imds);
minSetCount = min(tbl{:,2});
% equalising number of images using minimum dataset category as a reference
imds2 = splitEachLabel(imds, minSetCount, 'randomize');
countEachLabel(imds2);
WearInsert = find(imds2.Labels == 'WearInserts', 1);
Residue = find(imds2.Labels == 'Residues', 1);


%% loading a residual network for image classification (resnet-50)
rng(1) 
net1 = resnet50;

%% viewing the resnet-50 architecture of layers
figure
plot(net1);
title('architecture of resnet-50');
set(gca, 'YLim', [150 170]);

%% training the resnet-50 with 80% of images from each category

[trainingSet, testSet] = splitEachLabel(imds2, 0.8, 'randomize');
imageSize = net1.Layers(1).InputSize;

% image augmentation
augmentedTrainingSet = augmentedImageDatastore(imageSize, trainingSet,...
    'ColorPreprocessing', 'gray2rgb');
AugmentedTestSet = augmentedImageDatastore(imageSize, testSet,...
    'ColorPreprocessing', 'gray2rgb');


%% testing/validating the classifier with remaining images from each category
testFeatures = activations(net1, AugmentedTestSet, featureLayer,...
    'MiniBatchSize', 32, 'Outputas','columns');

[predictLabels,scores] = predict(classifier, testFeatures, 'ObservationsIn','columns');
testLables = testSet.Labels;
 
%% standardise scores

%% Plotting AUC and PR curves
% hold on
% for i=1:length(testLables)
%     [xr, yr, ~, auc] = perfcurve(testLables,scores(:, i), testLables(i));
%     plot(xr, yr, 'linewidth', 1)
%     legends{i} = sprintf('AUC for %s class: %.3f', testLables{i}, auc);
% end
% 
% legend(legends, 'location', 'southeast')
% line([0 1], [0 1], 'linestyle', ':', 'color', 'k');
% xlabel('FPR'), ylabel('TPR')
% title('ROC for Iris Classification (1 vs Others)')
% axis square


%% visualising the confusion matrix from actual categories and predicted categories
confMat = confusionmat(testLables, predictLabels);
figure ('Units','normalized','Position',[0.2 0.2 0.4 0.4]);
cm = confusionchart(testLables, predictLabels);
cm.Title = 'Confusion Matrix for Validation Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';

%% calculating the accurancy, recall sensitivity and precision of the classifier
tp_m = diag(confMat);
for i = size(confMat)
    TP = tp_m(i);
    FP = sum(confMat(:, i), 1) - TP;
    FN = sum(confMat(i, :), 2) - TP;
    TN = sum(confMat(:)) - TP - FP - FN;
    
    Accuracy = (TP+TN)./(TP+FP+TN+FN)% Accuracy
    
    TPR = TP./(TP + FN)%tp/actual positive RECALL SENSITIVITY
    if isnan(TPR)
        TPR = 0;
    end
    
    PPV = TP./ (TP + FP) % tp / predicted positive PRECISION
    if isnan(PPV)
        PPV = 0;
    end
    
    TNR = TN./ (TN+FP) %tn/ actual negative SPECIFICITY
    if isnan(TNR)
        TNR = 0;
    end
    
    FPR = FP./ (TN+FP);
    if isnan(FPR)
        FPR = 0;
    end
    
    FScore = (2*(PPV * TPR))./(PPV+TPR);
    if isnan(FScore)
        FScore = 0;
    end
end

%% testing the algorithm with a known image.
% img1 = imread('image1267.jpg');
% ds = augmentedImageDatastore(imageSize, img1,...
%     'ColorPreprocessing', 'gray2rgb');
% imageFeatures = activations(net1, ds, featureLayer,...
%     'MiniBatchSize', 32, 'Outputas','columns');
% label1 = predict(classifier, imageFeatures, 'ObservationsIn','columns')

%% 



%% plotting probability
% [predictLabels,probs] = predict(classifier, testFeatures, 'ObservationsIn','columns');
% 
% idx = [1 5 12 45 16 30 21 22 25 70 72 20 35 41 50  55];
% figure
% for i = 1:numel(idx)
%     subplot(4,4,i)
%     I = readimage(testSet,idx(i));
%     imshow(I)
%     label1 = predictLabels(idx(i));
%     title(string(label1) + ", " + num2str(max(probs(idx(i),:)+100),3) + '%');
%     switch label1
% % %         case 'RakeWear'
% % %             sprintf('The loaded image belongs to %s class', label)
% % %             Remedies = {'lower speed';'lower feed'};
% % %             B1 = [1;2];
% % %             T1 = table(B1,Remedies);
% % %             disp(T1)
% % %         case 'flankWear'
% % %             sprintf('The loaded image belongs to %s class', label)
% % %             Remedies = {'use high wear resistance tool';'increase feed';'lower speed';'increase flank angle'};
% % %             B1 = [1;2;3;4];
% % %             T1 = table(B1,Remedies);
% % %             disp(T1)
% % %         case 'NoseWear'
% % %             sprintf('The loaded image belongs to %s class', label)
% % %             Remedies = {'use high toughness tool grade';'lower feed';'reduce speed';'apply proper lubricant'};
% % %             B1 = [1;2;3;4];
% % %             T1 = table(B1,Remedies);
% % %             disp(T1)
%  % mechanism based wear           
%         case 'NotchWear'
%             sprintf('The loaded image belongs to %s class', label1)
%             Remedies = {'use high wear resistance tool';'increase rake angle'};
%             B1 = [1;2];
%             T1 = table(B1,Remedies);
%             disp(T1)
%        
%         case 'thermalWear'
%             sprintf('The loaded image belongs to %s class', label1)
%             Remedies = {'use high wear resistance tool';'lower feed';'lower speed';'reduce depth of cut'};
%             B1 = [1;2;3;4];
%             T1 = table(B1,Remedies);
%             disp(T1)
%         case 'chipping'
%             sprintf('The loaded image belongs to %s class', label1)
%             Remedies = {'use high toughness tool grade';'lower feed';'use large shank size';'increase honing'};
%             B1 = [1;2;3;4];
%             T1 = table(B1,Remedies);
%             disp(T1)
%         case 'adhension'
%             sprintf('The loaded image belongs to %s class', label1)
%             Remedies = {'use proper coolant';'use high wear resistant tool';'lower speed';'lower feed'};
%             B1 = [1;2;3;4];
%             T1 = table(B1,Remedies);
%             disp(T1)
%         case 'abrasion'
%             sprintf('The loaded image belongs to %s class', label1)
%             Remedies = {'use high wear resistance tool';'increase speed';'reduce feed';'use proper lubricant'};
%             B1 = [1;2;3;4];
%             T1 = table(B1,Remedies);
%             disp(T1)
%             
%     end
% end
% %% calling segmentation function for regiona area extraction making IMG2 a reference image on surface
% % img2 = imread('wear1.JPG');
% % AreaExtraction = segmentationFunction(img1, img2);

%% save the model
