function I = detectToolWear(dataIn)

% resizing 
targetSize = [227,227,3];
imdsReSz=im2single(imresize(dataIn,targetSize(1:2)));

%take the variables from the workspace
%mainnet=evalin('base','mainnet');
%networkOutputs=evalin('base','networkOutputs');
anchorBoxes=evalin('base','anchorBoxes');
anchorBoxMasks=evalin('base','anchorBoxMasks');
confidenceThreshold=0.6;
overlapThreshold=0.6;
classNames=evalin('base','classNames');

% Get the image.
I = imdsReSz;

% Convert to dlarray.
XTest = dlarray(I, 'SSCB');
executionEnvironment = "auto";

% If GPU is available, then convert data to gpuArray.
if (executionEnvironment == "auto" && canUseGPU) || executionEnvironment == "gpu"
    XTest = gpuArray(XTest);
end

[bboxes,scores,labels] = detect(yolov3detector,XTest);


% Number of objects detected
i=numel(cell2mat(scores));
label_cell = cell(i,1); 
conf_val = cell2mat(scores);      
conf_lab = [labels{:}];
position=cell2mat(bboxes);

for ii=1:i
    
     label_cell{ii} = [sprintf('%s', conf_lab(ii,1)) ', ' num2str(conf_val(ii,1), '%0.2f')]; 
    
end
% Display the detections on image.
if ~isempty(scores{1})

    I = insertObjectAnnotation(I, 'rectangle', position, label_cell,...
        'TextBoxOpacity',0.9,'FontSize',8);

end

end