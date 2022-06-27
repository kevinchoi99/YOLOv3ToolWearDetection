function SV_Features = divide_image_into_blocks(Image) 
%This function has an input called Image
%The function is used to divide the image into 5-sections and try to visualise the sections and extract
% magnitudes of singular values. This function is calls a function
% called SVD_Improved_V to help perform SVD decomposition of an
% image-section where S (Singular values) are extracted for further
% analysis. The function will also calculates the magnitudes of singular
% values by using a Matlab command called L2-Norm. Som graphs have been
% plotted to visualise the compression ratio, relative norms and root mean
% square errors for various ranks of the image.

%% Loading an Image and segmenting
% Image = imread('40_0.07_1_1_3600.tif');
% Image = imrotate(Image,90);
% Image = rgb2gray(Image);
img1 = Image;

R = 288; C = 1920;q=60;
NumberofBlocks = size(img1,1)*size(img1,2) / (R*C);
dividedImage = zeros([R C NumberofBlocks]);
ImageRows = 1;
ImageColumns = 1;
try
    for count=1:NumberofBlocks
        NewImage(:,:,count) = img1(ImageRows:ImageRows+R-1,ImageColumns:ImageColumns+C-1);
        ImageColumns = ImageColumns + C;
        if(ImageColumns >= size(img1,2))
            ImageColumns = 1;
            ImageRows = ImageRows + R;
            if(ImageRows >= size(img1,1))
                ImageRows = 1;
            end
        end
    end
end

%% separate the blocks of image 

A1 = NewImage(:,:,1);
A2 = NewImage(:,:,2);
A3 = NewImage(:,:,3);
A4 = NewImage(:,:,4);
A5 = NewImage(:,:,5);
%% visulaising the slices of image created
% figure
% subplot(6,1,1);
% imshow (img1)
% 
% subplot(6,1,2);
% imshow (A1)
% 
% subplot(6,1,3);
% imshow (A2)
% 
% subplot(6,1,4);
% imshow (A3)
% 
% subplot(6,1,5);
% imshow (A4)
% 
% subplot(6,1,6);
% imshow (A5)

%% Apply SVD in each section of the sub-image

[~,S_A1,~,~,~,~,~,~]= SVD_Improved(A1);

[~,S_A2,~,~,~,~,~,~]= SVD_Improved(A2);

[~,S_A3,~,~,~,~,~,~]= SVD_Improved(A3);

[~,S_A4,~,~,~,~,~,~]= SVD_Improved(A4);

[~,S_A5,~,~,~,~,~,~]= SVD_Improved(A5);

%% Extracting singular values for image sections

SingularValues_A1 = S_A1(6:60,:);
SingularValues_A2 = S_A2(6:60,:);
SingularValues_A3 = S_A3(6:60,:);
SingularValues_A4 = S_A4(6:60,:);
SingularValues_A5 = S_A5(6:60,:);

%% calculating magnitude of the eigen values with rank = 60 for all image sections

Magnitude_A1 = norm(SingularValues_A1.^2);
Magnitude_A2 = norm(SingularValues_A2.^2);
Magnitude_A3 = norm(SingularValues_A3.^2);
Magnitude_A4 = norm(SingularValues_A4.^2);
Magnitude_A5 = norm(SingularValues_A5.^2);

%% Finding Magnitudes of Singular vectors U
% Magnitude_U_A1 = norm(U_A1);
% Magnitude_U_A2 = norm(U_A2);
% Magnitude_U_A3 = norm(U_A3);
% Magnitude_U_A4 = norm(U_A4);
% Magnitude_U_A5 = norm(U_A5);

%% Finding magnitudes of singular vector V
% Magnitude_V_A1 = norm(V_A1);
% Magnitude_V_A2 = norm(V_A2);
% Magnitude_V_A3 = norm(V_A3);
% Magnitude_V_A4 = norm(V_A4);
% Magnitude_V_A5 = norm(V_A5);

%% Combinations of magnitudes for image sections
% combining magnitudes of singular values
Magnitude_A2A3 = Magnitude_A2 + Magnitude_A3;
Magnitude_A1A2A3 = Magnitude_A1 + Magnitude_A2 + Magnitude_A3;
Magnitude_A2A3A4 = Magnitude_A2 + Magnitude_A3 + Magnitude_A4;
Magnitude_A2A3A4A5 = Magnitude_A2 + Magnitude_A3 + Magnitude_A4 + Magnitude_A5;
Magnitude_A4A5 = Magnitude_A4 + Magnitude_A5;

% combining magnitudes of left singular values
% Magnitude_U_A2A3 = Magnitude_U_A2 + Magnitude_U_A3;
% Magnitude_U_A1A2A3 = Magnitude_U_A1 + Magnitude_U_A2 + Magnitude_U_A3;
% Magnitude_U_A2A3A4 = Magnitude_U_A2 + Magnitude_U_A3 + Magnitude_U_A4;
% Magnitude_U_A2A3A4A5 = Magnitude_U_A2 + Magnitude_U_A3 + Magnitude_U_A4 + Magnitude_U_A5;
% Magnitude_U_A4A5 = Magnitude_U_A4 + Magnitude_U_A5;
% 
% % combining magnitudes of right singular values
% Magnitude_V_A2A3 = Magnitude_V_A2 + Magnitude_V_A3;
% Magnitude_V_A1A2A3 = Magnitude_V_A1 + Magnitude_V_A2 + Magnitude_V_A3;
% Magnitude_V_A2A3A4 = Magnitude_V_A2 + Magnitude_V_A3 + Magnitude_V_A4;
% Magnitude_V_A2A3A4A5 = Magnitude_V_A2 + Magnitude_V_A3 + Magnitude_V_A4 + Magnitude_V_A5;
% Magnitude_V_A4A5 = Magnitude_V_A4 + Magnitude_V_A5;

%% Assigning features to variables
SV_Features = [Magnitude_A2A3,Magnitude_A1A2A3,Magnitude_A2A3A4,Magnitude_A2A3A4A5,Magnitude_A4A5]';
% U_Features = [Magnitude_U_A2A3,Magnitude_U_A1A2A3,Magnitude_U_A2A3A4,Magnitude_U_A2A3A4A5,Magnitude_U_A4A5]';
% V_Features = [Magnitude_V_A2A3,Magnitude_V_A1A2A3,Magnitude_V_A2A3A4,Magnitude_V_A2A3A4A5,Magnitude_V_A4A5]';

%% Plotting performance graphs
% % Plotting the relative norm of each image section
% figure 
% plot(1:q,Relative_Norm_A1,'MarkerEdgeColor','r','MarkerEdgeColor','g'); hold on;
% plot(1:q,Relative_Norm_A2,'MarkerEdgeColor','r','MarkerEdgeColor','g'); hold on;
% plot(1:q,Relative_Norm_A3,'MarkerEdgeColor','r','MarkerEdgeColor','g'); hold on;
% plot(1:q,Relative_Norm_A4,'MarkerEdgeColor','r','MarkerEdgeColor','g'); hold on;
% plot(1:q,Relative_Norm_A5,'MarkerEdgeColor','r','MarkerEdgeColor','g'); hold off;
% 
% xlabel('Approximation Rank r'); 
% ylabel('Relative 2-Norm'); 
% xlim([1 q]); legend('section A1','Section A2','Section A3', 'Section A4','Section A5'); 
% 
% % Plotting the room mean square errors of each image section
% figure 
% plot(1:q,rmse_A1,'MarkerEdgeColor','r','MarkerEdgeColor','g'); hold on;
% plot(1:q,rmse_A2,'MarkerEdgeColor','r','MarkerEdgeColor','g'); hold on;
% plot(1:q,rmse_A3,'MarkerEdgeColor','r','MarkerEdgeColor','g'); hold on;
% plot(1:q,rmse_A4,'MarkerEdgeColor','r','MarkerEdgeColor','g'); hold on;
% plot(1:q,rmse_A5,'MarkerEdgeColor','r','MarkerEdgeColor','g'); hold off;
% 
% xlabel('Approximation Rank r');
% ylabel('Root Mean Square Error');
% xlim([1 q]); legend('section A1','Section A2','Section A3', 'Section A4','Section A5'); 
% 
% % Plotting the compression ratio of each image section
% figure
% plot(1:q,compression_ratio_A1); hold on;
% plot(1:q,compression_ratio_A2); hold on;
% plot(1:q,compression_ratio_A3); hold on;
% plot(1:q,compression_ratio_A4); hold on;
% plot(1:q,compression_ratio_A5); hold off;
% 
% xlabel('Approximation Rank r'); 
% ylabel('Compression Ratio'); xlim([1 q])
% xlim([1 q]); legend('section A1','Section A2','Section A3', 'Section A4','Section A5'); 
