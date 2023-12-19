function [maskedBW] = Mask_Image_wCentroid(I)

%This function allows me to mask my images such that pixels outside of a
%circle are removed. This code is adapted from the circle_masking_demo.m
%file from https://www.mathworks.com/matlabcentral/answers/839200-create-circular-mask-and-assign-zero-outside-the-mask-in-an-image#answer_708390


% % Read in the image from disk.
% originalImage = imread(I);

% Get the dimensions of the image.  numberOfColorBands should be = 1.
[rows, columns, numberOfColorBands] = size(I);

% Calculate the centroid of main spheroid in the image
[spheroid_centroid, spheroid_area, ~, ~, ~, ~] = Find_SpheroidCentroid(I);
close 

% Initialize parameters for the circle and frame (e.g. location, radius).
circleCenterX = spheroid_centroid(1); 
circleCenterY = spheroid_centroid(2); 
circleRadius = size(I,1)/2;   
centroid_center = [round(circleCenterX), round(circleCenterY)];

frameCenterX = size(I,2)/2; 
frameCenterY =  size(I,1)/2; 
frame_center = [frameCenterX, frameCenterY];


% Display the original image.
figure
subplot(1, 3, 1);
imshow(I, []);
title('Original Image');

% Enlarge figure to full screen.
set(gcf, 'Position', get(0,'Screensize')); 
set(gcf,'name','Image Analysis Demo','numbertitle','off') 

% Initialize an image to a logical image of the circle. 
circleImage = false(rows, columns); 
[x, y] = meshgrid(1:columns, 1:rows); 
circleImage((x - circleCenterX).^2 + (y - circleCenterY).^2 <= circleRadius.^2) = true; 

% Display it in plot. 
subplot(1, 3, 2);
imshow(circleImage, []); 
title('Circle Mask'); 
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
drawnow;

%- Add annotation about mask location
annstr = {strcat('centroid center: (', num2str(centroid_center), ')') , ...
    strcat('frame center: (', num2str(frame_center), ')')} ; 

annpos = [0.46 0.25 0.1 0.1]; % annotation position in figure coordinates
ann = annotation('textbox',annpos,'string',annstr, 'FitBoxtoText', 'on');


% Mask the image with the circle.
if numberOfColorBands == 1
	maskedBW = I; % Initialize with the entire image.
	maskedBW(~circleImage) = 0; % Zero image outside the circle mask.
else
	% Mask the image.
	maskedBW = bsxfun(@times, originalImage, cast(circleImage,class(I)));
end

% Display it in plot. 
subplot(1, 3, 3); 
imshow(maskedBW, []); 
title('Image masked with the circle'); 



