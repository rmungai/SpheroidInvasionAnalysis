%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; April 2022

function [filledBW] = Binarize_Image(image, image_day)
% This function reads in an image and returns a binarized version of it 

%% Read the image and display it
I = imread(image);

% Display the image.
figure 
subplot(1, 2, 1);
imshow(I);
captionFontSize = 14;
caption = sprintf('Original given image');
title(caption, 'FontSize', captionFontSize);
axis('on', 'image'); % Make sure image is not artificially stretched because of screen's aspect ratio.

%% Check to make sure that it is grayscale, and if not, make it gray
[rows, columns, numberOfColorChannels] = size(I);


if numberOfColorChannels > 1
	% Automatically convert to grayscale - comment out if you want 
    % user to choose
    printMessage = sprintf('Your image file has color channels.\nThis script was designed for grayscale images.\nConverting to grayscale now')
	
    % %Uncomment if user input is desired
    % promptMessage = sprintf('Your image file has %d color channels.\nThis script was designed for grayscale images.\nDo you want me to convert it to grayscale for you so you can continue?', numberOfColorChannels);
	% button = questdlg(promptMessage, 'Continue', 'Convert and Continue', 'Cancel', 'Convert and Continue');
	% if strcmp(button, 'Cancel')
	% 	fprintf(1, 'Cancelled by user\n');
	% 	return;
	% end
	% Do the conversion using standard book formula
	I = rgb2gray(I);
end


% Display the grayscale image
subplot(1, 2, 2);
imshow(I);
caption = sprintf('Grayscale conversion (if needed)');
title(caption, 'FontSize', captionFontSize);
axis('on', 'image');


% Enlarge figure to full screen.
set(gcf, 'Position', get(0,'Screensize')); 



%% . . . . . . . . . . . . . . . . . . . . . . . . . . . . 

%Subtract a constant value from the image to reduce background.

if sum(I(:) == 0)== 0 %If there are no pixels valuing zero in the image
    subI = imsubtract(I,50); %50 pixels
else   
    subI = imsubtract(I,0); 
    disp('no need to subtract background')
end
% figure
% imshowpair(I, subI, 'montage') %subI


%% . . . . . . . . . . . . . . . . . . . . . . . . . . . . 

% Sharpen image
sharpI = imsharpen(subI); %(subI)
% figure
% imshow(sharpI)

% . . . . . . . . . . . . . . . . . . . . . . . . . . . . 



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


%% . . . . . . . . . . . . . . . . . . . . . . . . . . . . 

%Convert the image to a binary image 

% - The Day 0 spheroid binarizes best with the auto global thresholding
% technique
if strcmp(image_day, 'day0')
    sharpBW = imbinarize(sharpI, 'global'); %auto global thresholding - works better for Day 0 spheroid

% - The Day 2 spheroid binarizes best with a specified value for the 
% global threshold (previously 0.16)
elseif strcmp(image_day, 'day2')    
    sharpBW = imbinarize(sharpI, 0.10); %can raise and lower as needed for your images

else
    disp('String comparison failed. Cannot binarize image.')

end

%sharpBW = imbinarize(sharpI, 'adaptive'); 
%sharpBW = imbinarize(sharpI, 0.16); %can raise and lower as needed for your images
%BW = imbinarize(I);  <--w/o specifying the threshold

% figure
% imshowpair(I, sharpBW, 'montage')



%% . . . . . . . . . . . . . . . . . . . . . . . . . . . . 

% %Dilate and erode the image  - Can change order if needed
se = strel("disk",3);
% se = strel('line',11,90);
deBW = imdilate(sharpBW, se);

%figure
%imshow(erodedBW)

deBW = imerode(deBW, se);

%se = strel("disk",3);
%erodedBW2 = imerode(dilatedBW, se);

% figure
% imshowpair(I, dilatedBW, 'montage')
%imshowpair(dilatedBW, erodedBW2, 'montage')


%% . . . . . . . . . . . . . . . . . . . . . . . . . . . . 

% Fill any remaining holes
filledBW = imfill(deBW, 'holes');

figure
subplot(1,2,1)
imshow(I)
title('Grayscale image', 'FontSize', captionFontSize);
axis('on', 'image');

subplot(1,2,2)
imshow(filledBW)
title('Final binary image', 'FontSize', captionFontSize);
axis('on', 'image');


% Enlarge figure to full screen.
set(gcf, 'Position', get(0,'Screensize')); 



end






