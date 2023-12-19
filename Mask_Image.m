function [maskedBW] = Mask_Image(I)

%This function allows me to mask my images such that pixels outside of a
%circle are removed. This code is adapted from the circle_masking_demo.m
%file from https://www.mathworks.com/matlabcentral/answers/839200-create-circular-mask-and-assign-zero-outside-the-mask-in-an-image#answer_708390


% % Read in the image from disk.
% originalImage = imread(I);

% Get the dimensions of the image.  numberOfColorBands should be = 1.
[rows, columns, numberOfColorBands] = size(I);

% Display the original image.
figure
subplot(1, 3, 1);
imshow(I, []);
title('Original Image');

% Enlarge figure to full screen.
set(gcf, 'Position', get(0,'Screensize')); 
set(gcf,'name','Image Analysis Demo','numbertitle','off') 

% Initialize parameters for the circle,
% such as it's location and radius.
circleCenterX = size(I,2)/2; 
circleCenterY =  size(I,1)/2; 
circleRadius = size(I,1)/2;    

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



