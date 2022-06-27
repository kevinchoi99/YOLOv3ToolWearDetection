function Predicted_values= Flank_Wear_Prediction(Image)            

               Image = rgb2gray(Image);
%                 Image = imadjust(I);

               %% Performing multi-sectional SVD of an image
               
               % calling SVD to extract singular values at rank 60
%                [U,S,V,rmse,Relative_Norm,compression_ratio, PSNR,SNR]= SVD_Improved(Image);
               
                % Dividing image into sections and extracting singular values
%                SV_Features = divide_image_into_blocks(Image);
                 %% calling features of multi-sectional SVD

                Magnitude_Features = SVD_Extraction_Features(Image);
                
                %assigning features to inputs 
                Model_input_x = Magnitude_Features;
                
                % normalising input data
              
                x_norm3_1 = (Model_input_x(:,1)-29217619.3558057)/(16036736.3947908); % M1
                x_norm3_2 = (Model_input_x(:,2)-30316706.961729)/(16644639.9283867); % M2
                x_norm3_3 = (Model_input_x(:,3)-35895508.4223139)/(18441772.0039614); % M3
                x_norm3_4 = (Model_input_x(:,4)-41227509.4712984)/(19785093.5249459); % M4
                x_norm3_5 = (Model_input_x(:,4)-41227509.4712984)/(19785093.5249459); % M5

                x_norm3_trp1 = [x_norm3_1,x_norm3_2,x_norm3_3,x_norm3_4,x_norm3_5]';

%                 VB_max = exp(WearNet_VB_max(x_norm3_trp1))-1;
                
                VB_Predicted = exp(WearNet_VB(x_norm3_trp1))-1;
                
                RUL_Features_input = [speed, Feed_rate, VB_Predicted];
                
%                 x_norm3_5 = (RUL_Features_input(:,1)-1632.92181069959)/(1113.88054004796); % length
                x_norm3_6 = (RUL_Features_input(:,2)-53.2510288065844)/(15.2298759298298); % speed
                x_norm3_7 = (RUL_Features_input(:,3)-0.0948148148148149)/(0.0244498700047801); % feed
%                 x_norm3_8 = (RUL_Features_input(:,4)-348.753823731139)/(301.83724041963); % VB_max
                x_norm3_8 = (RUL_Features_input(:,5)-228.833280178327)/(184.704089394849); % VB_Predicted
                
                x_norm3_trp2 = [x_norm3_6,x_norm3_7,x_norm3_8]';
                
                RUL_predicted = exp(WearNet_RUL(x_norm3_trp2))-1;
                
                if VB_Predicted < 100 
                   sprintf('Early wear')
                   sprintf('continue cutting')
                elseif (VB_Predicted > 100) && (VB_Predicted< 200) 
                   sprintf('Uniform Wear')
                   sprintf('continue cutting')
                elseif (VB_Predicted > 200) && (VB_Predicted< 500) 
                   sprintf('severe wear')
                   sprintf('continue cutting')
                else 
                   sprintf('end of tool life')
                   sprintf('change the cutting tools')
    
                end
               
                Predicted_values = [VB_Predicted, RUL_predicted];