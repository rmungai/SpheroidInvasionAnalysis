%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; April 2022

function [dilatedBW] = Binarize_Image(image)
% This function reads in an image and returns a binarized version of it 

%Read the image and display it
I = imread(image);
% figure
% imshow(I)


%Subtract a constant value from the image to reduce background.
if sum(I(:) == 0)== 0 %If there are no pixels valuing zero in the image
    subI = imsubtract(I,50); %50 pixels
else   
    subI = imsubtract(I,0); 
    disp('no need to subtract background')
end
% figure
% imshowpair(I, subI, 'montage') %subI


%Sharpen image //////////////////////////////////////////////
sharpI = imsharpen(subI); %(subI)
% figure
% imshow(sharpI)
%////////////////////////////////////////////////////////////


% %Trying different adjustment techniques
%adjI = imadjust(subI);
%adjI = adapthisteq(sharpI);
%adjI = imcontrast;
%J = imadjust(I,[0.3 0.7],[]);
%figure
%imshow(adjI)


% % Subtract the image background using a generated background image
% background = imopen(I,strel('disk',15));
% subI = imsubtract(I,background);
%
% %Enhance Contrast Using Bottom-hat and Top-hat Filtering
% se = strel('disk',3); %Create a disk-shaped structuring element.
% background2 = imbothat(I,se);
% subI2 = imsubtract(imadd(I,imtophat(I,se)),background);
% figure
% imshowpair(background, background2, 'montage')



%Convert the image to a binary image ///////////////////////////////////
%BW = imbinarize(I);  <--w/o specifying the threshold
% subBW = imbinarize(subI, 0.14); %Threshold = 0.14, rasied from 0.12
% figure
% imshowpair(I, subBW, 'montage')

%sharpBW = imbinarize(sharpI, 'adaptive'); 
%sharpBW = imbinarize(sharpI, 0.16); %rasied from 0.14, 0.12 to get rid of outlier pixels
sharpBW = imbinarize(sharpI, 0.28); %tesing low/high threshold 0.16 +/- M6)


% figure
% imshowpair(I, sharpBW, 'montage')
%////////////////////////////////////////////////////////////////////


% %Erode then dilate the image - Can also try flipping if needed
se = strel("disk",3);
% se = strel('line',11,90);
erodedBW = imerode(sharpBW, se);

%figure
%imshow(erodedBW)

dilatedBW = imdilate(erodedBW, se);

%se = strel("disk",3);
%erodedBW2 = imerode(dilatedBW, se);

figure
imshowpair(I, dilatedBW, 'montage')
%imshowpair(dilatedBW, erodedBW2, 'montage')


end






