
%image_folder = 'C:\Users\Kevin\OneDrive - University of Nottingham Malaysia\Documents\Study\FYP\final\Final YOLOv3 Detector\Testing images\VCXU-65M.R_700006003432_220224-170122'

%% changing all thermal images to gray image
load('trainedResNet3.mat')


filenames = dir(fullfile(image_folder, '*.tif'));  
total_images = numel(filenames);
tday = datetime(now,'Format','yyyy-MM-dd','convertFrom','datenum');
ttime = datetime(now,'Format','HH.mm.ss','convertFrom','datenum');
mainfolder = fullfile(outputdestination,'Wear Inserts');

    if ~exist(mainfolder,'dir')
        mkdir(mainfolder)
    end

wearfoldername = 'Wear Insert %s';
wearfolder = sprintf(wearfoldername,tday);
wearfolder2 = fullfile(mainfolder,wearfolder);

    if ~exist(wearfolder2, 'dir')
       mkdir(wearfolder2)
    end

wearfiles = sprintf(wearfoldername,ttime);
wearfiles2 = fullfile(wearfolder2,wearfiles);
mkdir(wearfiles2)
 

 for n = 1:total_images
     full_name= fullfile(image_folder, filenames(n).name);
     our_images = imread(full_name);

     ds = augmentedImageDatastore(imageSize, our_images,...
    'ColorPreprocessing', 'gray2rgb');
     imageFeatures = activations(net1, ds, featureLayer,...
    'MiniBatchSize', 32, 'Outputas','columns');
     label1 = predict(classifier, imageFeatures, 'ObservationsIn','columns');
     switch label1
           case 'WearInserts'
                %sprintf('The loaded image belongs to %s class', label1)
                A = our_images;
                %imshow(our_images)
                [image_folder, baseFileNameNoExtenstion, ext] = fileparts(full_name);
                newFilename = [baseFileNameNoExtenstion, '.tif'];
                newfoldername = fullfile(wearfolder2,wearfiles);
                newFile = fullfile(newfoldername, newFilename);
                newfilepath = fullfile(pwd,newFile);
                imwrite(our_images, newFile,'tif');
       
           case 'Residues'
                %sprintf('The loaded image belongs to %s class', label1)
                A = our_images;
                %imshow(our_images)
                [image_folder, baseFileNameNoExtenstion, ext] = fileparts(full_name);
                newFilename = [baseFileNameNoExtenstion, '.tif'];
                newfoldername = fullfile(wearfolder2,wearfiles);
                newFile = fullfile(newfoldername, newFilename);
                newfilepath = fullfile(pwd,newFile);
                imwrite(our_images, newFile,'tif');
                
     end
 end

