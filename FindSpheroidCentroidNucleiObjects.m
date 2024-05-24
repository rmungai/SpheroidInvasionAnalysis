% Script to analyze the values obtained for all methods for 
% Nuclear orientation of multicellular spheroids


% Rozanne Mungai May 2024
% Based on BlobsQuant.m code that I wrote in April 2024


function [spheroid_centroid, spheroid_area, FE_centroids, pixel_locs, boundary_pixel_locs, rprops_areas_filtered, rprops_centroids_filtered] = FindSpheroidCentroidNucleiObjects(binary_image, ~, ~)


% %% Binarize image
% % 
% % % Demo method: Set specific threshold -----------------------------------
% % % Method #1: using im2bw()
% %   normalizedThresholdValue = 0.4; % In range 0 to 1.
% %   thresholdValue = normalizedThresholdValue * max(max(originalImage)); % Gray Levels.
% %   binaryImage = im2bw(originalImage, normalizedThresholdValue);       % One way to threshold to binary
% % .
% % Method #2: using a logical operation.
% % - To choose bright objects on dark background use >
% % - To choose dark objects on bright background use <
% thresholdValue = 100;
% binaryImage = originalImage > thresholdValue;
% 
% % Trying Locally adaptive thresholding ---------------------------
% binaryImageL = imbinarize(originalImage, 'adaptive');
% 
% % Trying Global auto thresholding ---------------------------
% binaryImageG = imbinarize(originalImage, 'global');
% 
% % Do a "hole fill" to get rid of any background pixels or "holes" inside the blobs.
% binaryImage = imfill(binaryImage, 'holes');
% binaryImageL = imfill(binaryImageL, 'holes');
% binaryImageG = imfill(binaryImageG, 'holes');
% 
% % se = strel('line',11,90);
% % binaryImage2 = imerode(binaryImage2, se);
% % binaryImage2 = imerode(binaryImage2, se);
% 
% % % Show the threshold as a vertical red bar on the histogram.
% % hold on;
% % maxYValue = ylim;
% % line([thresholdValue, thresholdValue], maxYValue, 'Color', 'r');
% % % Place a text label on the bar chart showing the threshold.
% % annotationText = sprintf('Thresholded at %d gray levels', thresholdValue);
% % % For text(), the x and y need to be of the data class "double" so let's cast both to double.
% % text(double(thresholdValue + 5), double(0.5 * maxYValue(2)), annotationText, 'FontSize', 10, 'Color', [0 .5 0]);
% % text(double(thresholdValue - 70), double(0.94 * maxYValue(2)), 'Background', 'FontSize', 10, 'Color', [0 0 .5]);
% % text(double(thresholdValue + 50), double(0.94 * maxYValue(2)), 'Foreground', 'FontSize', 10, 'Color', [0 0 .5]);
% 
% 
% % % Comparing thresholding techniques........
% % figure
% % subplot(2, 2, 1);
% % imshow(originalImage);
% % title('Original grayscale')
% % 
% % % Display the binary image.
% % 
% % subplot(2, 2, 2);
% % imshow(binaryImage);
% % title('manual threshold  = 100')
% % 
% % subplot(2, 2, 3);
% % imshow(binaryImageL);
% % title('auto threshold: adaptive local')
% % 
% % subplot(2, 2, 4);
% % imshow(binaryImageG);
% % title('auto threshold: global')
% % sgtitle('Image Binarization by Different Thresholding Techniques');
% 
% % Show chosen thresholding technique: global auto thresholding
% binaryImage = binaryImageG;
% 
% %figure(1)
% subplot(1, 2, 2);
% imshow(binaryImage);
% 
% caption = sprintf('Auto threshold: global');
% title(caption, 'FontSize', captionFontSize);
% axis('on', 'image'); % Make sure image is not artificially stretched because of screen's aspect ratio.
% 


%%
%------------------------------------------------------------------------------------------------------------------------------------------------------
% Identify individual blobs by seeing which pixels are connected to each other.  This is called "Connected Components Labeling".
% Each group of connected pixels will be given a label, a number, to identify it and distinguish it from the other blobs.
% Do connected components labeling with either bwlabel() or bwconncomp().

[labeledImage, numberOfBlobs] = bwlabel(binary_image, 8);     % Label each blob so we can make measurements of it
% labeledImage is an integer-valued image where all pixels in the blobs have values of 1, or 2, or 3, or ... etc.

figure

% Label the blobs with grayscale shades
% subplot(1, 2, 1);
% imshow(labeledImage, []);  % Show the gray scale image.
% 
% % Maximize the figure window.
% hFig2 = gcf;
% hFig2.Units = 'normalized';
% hFig2.WindowState = 'maximized'; % Go to full screen.
% 
% caption = sprintf('Labeled Image, from bwlabel()');
captionFontSize = 14;
% title(caption, 'FontSize', captionFontSize);
% axis('on', 'image'); 



% Let's assign each blob a different color to visually show the user the distinct blobs.
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); % pseudo random color labels
% coloredLabels is an RGB image.  We could have applied a colormap instead (but only with R2014b and later)
%subplot(1, 2, 2);
imshow(coloredLabels);
%axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
caption = sprintf('All objects with pseudo colored labels from label2rgb()');
title(caption, 'FontSize', captionFontSize-4);
axis('on', 'image'); % Make sure image is not artificially stretched because of screen's aspect ratio.

drawnow;

%% ======================================================================================================================================================

%Try to segment individual clumps using watershed(?)
% - https://www.mathworks.com/help/images/ref/watershed.html#description




% MAIN PART IS RIGHT HERE!!!
% Get all the blob properties.

% props = regionprops(binaryImage, 'all');
% % Or, if you want, you can ask for only a few specific measurements.  This will be faster since we don't have to compute everything.
% % props = regionprops(labeledImage, originalImage, 'MeanIntensity', 'Area', 'Perimeter', 'Centroid', 'EquivDiameter');
% numberOfBlobs = numel(props); % Will be the same as we got earlier from bwlabel().


% My attempts at isolating only single nuclei ...............
CC = bwconncomp(binary_image); 
props = regionprops('table',CC, 'Area', 'PixelIdxList', 'Centroid');

% Enclosing in brackets is a nice trick to concatenate all the values
% from all the structure fields (every structure in the props structure array).
rprops_areas = props.Area;
rprops_pixel_list = props.PixelIdxList;
rprops_centroids = props.Centroid;



% % Filter connected components based on area
% keep_idx = find(area >= 10 & area <= 300);
% 
% % Create a new binary image with desired connected components
% output_image = false(size(binaryImage));
% for idx = keep_idx
%     output_image = output_image | (pixel_list{idx});
% end

% Filter connected components based on area
selection = (rprops_areas > 30) & (rprops_areas < 300);
filteredbinaryImage = cc2bw(CC,ObjectsToKeep=selection); %Requires R2024

% figure
% imshow(filteredbinaryImage)
% caption = sprintf('Binarized image filtered to only keep blobs 10-300 px^2');
% title(caption, 'FontSize', captionFontSize);
% axis('on', 'image'); % Make sure image is not artificially stretched because of screen's aspect ratio.

% Re do region props for the filtered image
[labeledFilteredImage, numberOfFilteredBlobs] = bwlabel(filteredbinaryImage, 8);
CC_f = bwconncomp(filteredbinaryImage); 
props_f = regionprops('table',CC_f, 'all');

%% ======================================================================================================================================================

%------------------------------------------------------------------------------------------------------------------------------------------------------
% PLOT BOUNDARIES.
% Plot the borders of single nuclei using the coordinates returned by bwboundaries().
% bwboundaries() returns a cell array, where each cell contains the row/column coordinates for an object in the image.

figure
subplot(1, 2, 1);
imshow(binary_image);

% Maximize the figure window.
hFig3 = gcf;
hFig3.Units = 'normalized';
hFig3.WindowState = 'maximized'; % Go to full screen.

title('Outlines over binary image', 'FontSize', captionFontSize);
axis('on', 'image'); 


% Here is where we actually get the boundaries for each blob. % - - - - -
boundaries = bwboundaries(filteredbinaryImage); % Note: this is a cell array with several boundaries -- one boundary per cell.
% boundaries is a cell array - one cell for each blob.
% In each cell is an N-by-2 list of coordinates in a (row, column) format.  Note: NOT (x,y).
% Column 1 is rows, or y.    Column 2 is columns, or x.
numberOfBoundaries = size(boundaries, 1); % Count the boundaries so we can use it in our for loop


% Here is where we actually PLOT the boundaries of each blob in the overlay.% - - - - 
hold on; % Don't let boundaries blow away the displayed image.
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k}; % Get boundary for this specific blob.
	x = thisBoundary(:,2); % Column 2 is the columns, which is x.
	y = thisBoundary(:,1); % Column 1 is the rows, which is x.
	plot(x, y, 'c-', 'LineWidth', 2); % Plot boundary in cyan color.
end
hold off;

% ------------------------------------------------------------------------------------------------------------------------------------------------------

% % Print out the measurements to the command window, and display blob numbers on the image below.
% textFontSize = 14;	% Used to control size of "blob number" labels put atop the image.
% % Print header line in the command window.
% fprintf(1,'Blob #        Area   Perimeter    Centroid       Diameter\n');


% Extract all the mean diameters into an array.
% The "diameter" is the "Equivalent Circular Diameter", which is the diameter of a circle with the same number of pixels as the blob.
% Enclosing in brackets is a nice trick to concatenate all the values from all the structure fields (every structure in the props structure array).
blobECD = [props_f.EquivDiameter];

rpropsOrientation = props_f.Orientation; %Get orientation
rpropsEccentricity = props_f.Eccentricity; %Get Eccentricity
rpropsCircularity = props_f.Circularity;
rpropsMajorAxis = props_f.MajorAxisLength;
rpropsMinorAxis = props_f.MinorAxisLength;
%meanGL = props_f.MeanIntensity;		% Get average intensity.
rprops_areas_filtered = props_f.Area;				% Get area.
rpropsPerimeter_filtered = props_f.Perimeter;		% Get perimeter.
rprops_centroids_filtered = props_f.Centroid;		% Get centroid one at a time





%% ------------------------------------------------------------------------------------------------------------------------------------------------------
% PLOT Outlines on a plain image.
% Plot the borders of all the nuclei on a plain white image.
subplot(1, 2, 2);
whiteImage = 255 * ones(1440, 1920, 'uint8');

imshow(whiteImage);
title('Outlines only', 'FontSize', captionFontSize);
axis('on', 'image'); 
% Here is where we actually get the boundaries for each blob.
boundaries = bwboundaries(filteredbinaryImage); % Note: this is a cell array with several boundaries -- one boundary per cell.
% boundaries is a cell array - one cell for each blob.
% In each cell is an N-by-2 list of coordinates in a (row, column) format.  Note: NOT (x,y).
% Column 1 is rows, or y.    Column 2 is columns, or x.
numberOfBoundaries = size(boundaries, 1); % Count the boundaries so we can use it in our for loop
% Here is where we actually plot the boundaries of each blob in the overlay.
hold on; % Don't let boundaries blow away the displayed image.
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k}; % Get boundary for this specific blob.
	x = thisBoundary(:,2); % Column 2 is the columns, which is x.
	y = thisBoundary(:,1); % Column 1 is the rows, which is x.
	plot(x, y, 'k-', 'LineWidth', 1); % Plot boundary in black.
end

caption = sprintf('Outlines of only blobs 30-300 px^2, from bwboundaries().\nBlobs are numbered from top to bottom, then from left to right.');
sgtitle(caption, 'FontSize', captionFontSize);


% % Now do the printing of this blob's measurements to the command window.
%j = (1 : numberOfFilteredBlobs)';
%fprintf(1,'#%2d %11.1f %8.1f %8.1f %8.1f % 8.1f\n', j, blobArea, blobPerimeter, blobCentroid, blobECD);

% Loop over all blobs printing their measurements to the command window.
for k = 1 : numberOfFilteredBlobs           % Loop through all blobs.
	% Find the individual measurements of each blob.  They are field of each structure in the props strucutre array.
	% You could use the bracket trick (like with blobECD above) OR you can get the value from the field of this particular structure.
	% I'm showing you both ways and you can use the way you like best.


	% Put the "blob number" labels next to the outlines on the plain outlines image.
	text(rprops_centroids_filtered(k,1)+16, rprops_centroids_filtered(k,2)+16, num2str(k),...
        'FontSize', 8, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color','b');

end



hold off;


%Find the centroid of the spheroid based from the unfiltered regionprops and plot on image
loc = find( rprops_areas == max(rprops_areas) );
spheroid_x_centroid = rprops_centroids(loc,1);
spheroid_y_centroid = rprops_centroids(loc,2);



%% Add FE props part
[image_stats] = FEprops(binary_image); 


%Store info using FEprops------------------------------------------------
FE_centroids = cat(1,image_stats.Centroid);
FE_areas = cat(1,image_stats.Area); %area in pixels
pixel_locs = cat(1,image_stats.PixelList); %locations of pixels
boundary_pixel_locs = cat(1,image_stats.BoundaryPixelList); %locations of element edge points


%Calculate the weighted centroid of the spheroid and plot on image
%---These are the locations of the average centroid weighted by the areas of the blobs
weighted_x_centroid = sum((FE_centroids(:,1) .* FE_areas)) / (sum(FE_areas));
weighted_y_centroid = sum((FE_centroids(:,2) .* FE_areas)) / (sum(FE_areas));

figure
imshow(binary_image)
hold on
plot(weighted_x_centroid,weighted_y_centroid,'r*')
plot(spheroid_x_centroid, spheroid_y_centroid, 'b*')
hold off
title('spheroid centroid')
legend('weighted', 'non-weighted')
axis('on', 'image');

%Compile final outputs
spheroid_centroid = [spheroid_x_centroid,spheroid_y_centroid];
spheroid_area = max(rprops_areas);
weighted_centroid = [weighted_x_centroid,weighted_y_centroid];




elapsedTime = toc;

 

end

	