currentFolder = ('C:\Users\Kevin\OneDrive - University of Nottingham Malaysia\Documents\Study\FYP\final\results\Online Image Acquistion Experiments\Online Image Acquisition\all images');
newFolder = ('C:\Users\Kevin\OneDrive - University of Nottingham Malaysia\Documents\Study\FYP\final\results\Online Image Acquistion Experiments\Online Image Acquisition\all images CLAHE');
ImageList = dir(fullfile(currentFolder, '*.tif'));
total_images = numel(ImageList);


for i = 1:total_images
     current_imagename = ImageList(i).name;
     current_imagename2 = fullfile(currentFolder,current_imagename);

     current_image = imread(current_imagename2);
     if ndims(current_image) == 2  %#ok<ISMAT> 
    % It's a 2D image.  Convert to 3-D.
        current_image = cat(3, current_image, current_image, current_image);
     end
    
     %CLAHE
     LAB = rgb2lab(current_image+30);
     L = LAB(:,:,1)/100;
     L = adapthisteq(L,'NumTiles',[8 8],'ClipLimit',0.005);
     LAB(:,:,1) = L*100;
     Image_CLAHE = lab2rgb(LAB);
     RegionInterest = [0 0 1300 1100];   % please fine tune the size of this rect to get the best result [0 0 1100 900]
     Image_Enlarge = imcrop(Image_CLAHE,RegionInterest);

     newFile = fullfile(newFolder,current_imagename);
     imwrite(Image_Enlarge, newFile,'tif');        

end