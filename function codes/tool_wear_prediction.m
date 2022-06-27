%% model deployment for different images.
%obtain the newest folder from the imagefolder
cameradestination = ('C:\Users\user\Pictures\Baumer Image Records\VCXU-65M.R');
run('obtainnewestfolder.m');
%specify the destination of output
outputdestination = pwd;
%Specify the folder of the images
%image_folder = 'C:\Users\Kevin\OneDrive - University of Nottingham Malaysia\Documents\Study\FYP\final\results\Online Image Acquistion Experiments\Online Image Acquisition\images to be included'; 
run('binaryclassifier.m');
addpath(mainfolder,wearfolder2,wearfiles2);
clearvars -except mainfolder wearfolder2 wearfiles2;
wearfolderdir = wearfiles2;
%loads the trained network
warning('off','all');
load('mainnet(0.001_0.0005_0.45)rev3.mat');
close(fig);
%This function calls all functions to execute the classification and
% prediction of tool wear and remaining useful life (RUL). The variables
% are Length, speed, and Feed rate.
%% Loading folder from online data acquisition
% change to the folderpath that store the images
imageStorageFolder = wearfiles2;
% get the all the jpg images in the folder 
imageFolder = dir(imageStorageFolder);
% identifying the number of files in the folder 
nfiles = numel(imageFolder);
% the newest folder will be the last folder
currentFolderName = imageFolder(nfiles).name;
currentFolder = imageFolder(nfiles).folder;
currentFolderPath = fullfile(currentFolder,currentFolderName);



% access the lastest folder and read the total number of images inside
ImageList = dir(fullfile(currentFolder, '*.tif'));
total_images = numel(ImageList);



% resize the image to [227 227 3] for conv1;
inputSize = baseNetwork.Layers(1).InputSize;
imds_our_images = imageDatastore(imageStorageFolder);

featureLayer = 'conv1';


Image_Montage = cell(total_images,1);
bottomposition = [0 800];
%%
for i = 1:total_images
     current_imagename = ImageList(i).name;
     current_image = imread(current_imagename);
     
     if ndims(current_image) == 2  %#ok<ISMAT> 
    % It's a 2D image.  Convert to 3-D.
        current_image = cat(3, current_image, current_image, current_image);
     end

     Image_Rot = imrotate(current_image,180);
                
     %CLAHE
     LAB = rgb2lab(Image_Rot+30);
     L = LAB(:,:,1)/100;
     L = adapthisteq(L,'NumTiles',[8 8],'ClipLimit',0.005);
     LAB(:,:,1) = L*100;
     Image_CLAHE = lab2rgb(LAB);
                
     %enlarging
     RegionInterest = [0 0 900 900];   % please fine tune the size of this rect to get the best result [0 0 1100 900] [100 0 1200 1100]
     Image_Enlarge = imcrop(Image_CLAHE,RegionInterest);

     %Resizing
     imdsReSz=im2single(imresize(Image_Enlarge,networkInputSize(1:2)));
     %I = imdsReSz;
     %I = Image_CLAHE;
     I = Image_Enlarge;
           
           
     %% call the Flank_Wear_Prediction function to deplay VB_max, VB_average and RUL
                
     %Predicted_values = Flank_Wear_Prediction(Image_Enlarge,Length,speed,Feed_rate);
                  
     %% Yolov3 detector to display image and B-Box
               
     [bboxes,scores,labels] = detect(yolov3Detector,I);

     % filter based on confidence
     conffilter = 0.1;
     scoresbelow = find(abs(scores)<conffilter);
     scoresupper = find(abs(scores)>conffilter);
     scores(scoresbelow) = 0;
     scoresfiltered = scores(scores~=0);
     bboxesfiltered = bboxes(scoresupper,:);
     labelsfiltered = labels(scoresupper,:);

     % Display the detections on image.
     Final_Image = insertText(I,bottomposition,current_imagename,'BoxColor','black','FontSize',50,'TextColor','white');
     
     if ~isempty(scoresfiltered)
                   
            Final_Image = insertObjectAnnotation(Final_Image,'rectangle',bboxesfiltered,labelsfiltered,'LineWidth',5,'TextBoxOpacity',0.5,'FontSize',40);
                        
     end 

     Image_Montage{i} = Final_Image;
       
          
end

run("showfigure.m");
save(append(wearfolderdir, '\Image Montage.mat'),"Image_Montage");
saveas(gca, fullfile(wearfolderdir, 'wearmontage'), 'jpeg');