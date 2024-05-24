%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; April 2022
% Find the centroid of the spheroid in the image and the pixels of
% migrating cells

function [spheroid_centroid, spheroid_area, FE_centroids, pixel_locs, boundary_pixel_locs, rprops_areas_filtered, rprops_centroids_filtered] = FindSphCentroid_FilterImage(binary_image)


[labeledImage, numberOfBlobs] = bwlabel(binary_image, 8);     % Label each blob so we can make measurements of it
% labeledImage is an integer-valued image where all pixels in the blobs have values of 1, or 2, or 3, or ... etc.

figure

captionFontSize = 14;


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

% Get the desired blob properties
CC = bwconncomp(binary_image); 
props = regionprops('table',CC, 'Area', 'PixelIdxList', 'Centroid');

%Store the x- and y-coordinates of the centroids into a two-column matrix.
% - Here using regionprops
rprops_areas = props.Area;
rprops_pixel_list = props.PixelIdxList;
rprops_centroids = cat(1, props.Centroid); 


% Filter connected components based on area - to get only single nuclei
selection = (rprops_areas > 30) & (rprops_areas < 300);
filteredbinaryImage = cc2bw(CC,ObjectsToKeep=selection); %Requires R2024

% figure
% imshow(filteredbinaryImage)
% caption = sprintf('Binarized image filtered to only keep blobs 10-300 px^2');
% title(caption, 'FontSize', captionFontSize);
% axis('on', 'image'); % Make sure image is not artificially stretched because of screen's aspect ratio.

%Create object labels for the filtered binary image
[labeledFilteredImage, numberOfFilteredBlobs] = bwlabel(filteredbinaryImage, 8);

% Re do region props for the filtered image
CC_f = bwconncomp(filteredbinaryImage); 
%props_f = regionprops('table',CC_f, 'Centroid', 'Area', 'PixelList');
props_f = regionprops('table',CC_f, 'all');




%% ======================================================================================================================================================

%------------------------------------------------------------------------------------------------------------------------------------------------------
% PLOT BOUNDARIES.
% Plot the borders of all the coins on the binarized image using the coordinates returned by bwboundaries().
% bwboundaries() returns a cell array, where each cell contains the row/column coordinates for an object in the image.

figure
subplot(1, 2, 1);
imshow(binary_image);

% Maximize the figure window.
hFig3 = gcf;
hFig3.Units = 'normalized';
hFig3.WindowState = 'maximized'; % Go to full screen.

caption = sprintf('Outlines of only blobs 30-300 px^2.\nBlobs are numbered from top to bottom, then from left to right.');
captionFontSize = 14;
title('Outlines, from bwboundaries()', 'FontSize', captionFontSize);
axis('on', 'image'); % Make sure image is not artificially stretched because of screen's aspect ratio.


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
	plot(x, y, 'c-', 'LineWidth', 2); % Plot boundary in cyan color.
end
hold off;

% ------------------------------------------------------------------------------------------------------------------------------------------------------

% Print out the measurements to the command window, and display blob numbers on the image.
textFontSize = 14;	% Used to control size of "blob number" labels put atop the image.
% Print header line in the command window.
fprintf(1,'Blob #        Area   Perimeter    Centroid       Diameter\n');


% % Extract all the mean diameters into an array.
% % The "diameter" is the "Equivalent Circular Diameter", which is the diameter of a circle with the same number of pixels as the blob.
% % Enclosing in brackets is a nice trick to concatenate all the values from all the structure fields (every structure in the props structure array).
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



    
% % Now do the printing of this blob's measurements to the command window.
% j = (1 : numberOfFilteredBlobs)';
%fprintf(1,'#%2d %11.1f %8.1f %8.1f %8.1f % 8.1f\n', j, blobArea, blobPerimeter, blobCentroid, blobECD);



% Loop over all blobs printing their measurements to the command window.
for k = 1 : numberOfFilteredBlobs           % Loop through all blobs.
	% Find the individual measurements of each blob.  They are field of each structure in the props strucutre array.
	% You could use the bracket trick (like with blobECD above) OR you can get the value from the field of this particular structure.
	% I'm showing you both ways and you can use the way you like best.
	
    	
	% Put the "blob number" labels on the grayscale image that is showing the cyan color boundaries on it.
	text(rprops_centroids_filtered(k,1)+16, rprops_centroids_filtered(k,2)+16, num2str(k),...
        'FontSize', 8, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color','y');
end



%% ------------------------------------------------------------------------------------------------------------------------------------------------------
% PLOT Outlines on a plain image.
% Plot the borders of all the nuclei on a plain white image.
subplot(1, 2, 2);
whiteImage = 255 * ones(1440, 1920, 'uint8');

imshow(whiteImage);
title('Outlines only', 'FontSize', captionFontSize);
axis('on', 'image'); % Make sure image is not artificially stretched because of screen's aspect ratio.


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

sgtitle(caption, 'FontSize', captionFontSize);



% Put the "blob number" labels on the plain outlines image 
	
for k = 1 : numberOfFilteredBlobs           % Loop through all blobs.
   	
	text(rprops_centroids_filtered(k,1)+16, rprops_centroids_filtered(k,2)+16, num2str(k),...
        'FontSize', 8, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color','b');
end



hold off;


% ==========================================================%




%Find the centroid of the spheroid based from regionprops and plot on image
loc = find( rprops_areas == max(rprops_areas) );
spheroid_x_centroid = rprops_centroids(loc,1);
spheroid_y_centroid = rprops_centroids(loc,2);

%% Add FE props part

% Calculate the properties using my FE props (pixel-based instead of object-based)
% - Enclosing in brackets concatenates all the values from all the structure fields 
[image_stats] = FEprops(filteredbinaryImage); 


%Store info using FEprops------------------------------------------------
%Decide here if you are using all the values or the sampled values -------
%All values
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
axis('on', 'image')  %Add axes to images


%Compile final outputs
spheroid_centroid = [spheroid_x_centroid,spheroid_y_centroid];
spheroid_area = max(rprops_areas);
weighted_centroid = [weighted_x_centroid,weighted_y_centroid];




end