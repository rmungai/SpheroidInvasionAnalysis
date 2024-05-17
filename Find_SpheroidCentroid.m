%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; April 2022
% Find the centroid of the spheroid in the image and the pixels of
% migrating cells

function [spheroid_centroid, spheroid_area, FE_centroids, rprops_areas, pixel_locs, boundary_pixel_locs] = Find_SpheroidCentroid(binary_image)

%function [weighted_centroid, rprops_centroids, spheroid_area, centroids, areas, pixel_locs, boundary_pixel_locs] = Find_SpheroidCentroid(binary_image)

%Show the image info in a table 
% including calculating the centroids of the 
% connected components in the image
stats = regionprops('table',binary_image,'Centroid', 'Area', 'PixelList');
[image_stats] = FEprops(binary_image); 

%Store the x- and y-coordinates of the centroids into a two-column matrix.
% - Here using regionprops
rprops_centroids = cat(1, stats.Centroid); 
rprops_areas = cat(1, stats.Area); 

%Store info using FEprops------------------------------------------------
%Decide here if you are using all the values or the sampled values -------
%All values
FE_centroids = cat(1,image_stats.Centroid);
FE_areas = cat(1,image_stats.Area); %area in pixels
pixel_locs = cat(1,image_stats.PixelList); %locations of pixels
boundary_pixel_locs = cat(1,image_stats.BoundaryPixelList); %locations of element edge points

% %Sampled values
% centroids = cat(1,sampled_stats.SpCentroid);
% areas = cat(1,sampled_stats.SpArea); %area in pixels
% pixel_locs = cat(1,sampled_stats.SpPixelList); %locations of pixels
% % -----------------------------------------------------------------------


% %Check centroids for debugging purposes -----------------------------
% figure
% plot(centroids(:,1),centroids(:,2), 'b*') 
%
% %Display the binary image with the centroid locations superimposed
% figure
% imshow(binary_image)
% hold on
% plot(FE_centroids(:,1),FE_centroids(:,2),'b*')
% hold off
% title('all centroids')


%areas = table2array(stats(:, 1));

%Find the centroid of the spheroid based from regionprops and plot on image
loc = find( rprops_areas == max(rprops_areas) );
spheroid_x_centroid = rprops_centroids(loc,1);
spheroid_y_centroid = rprops_centroids(loc,2);


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


%Compile final outputs
spheroid_centroid = [spheroid_x_centroid,spheroid_y_centroid];
spheroid_area = max(rprops_areas);
weighted_centroid = [weighted_x_centroid,weighted_y_centroid];
