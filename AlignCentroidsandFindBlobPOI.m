%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; April 2022

function [outer_blobs, poly_boundary, centered_boundary] = AlignCentroidsandFindBlobPOI(boundary, ...
    binary_image, centroid_loc, centroid_loc2, blob_centroids, boundary_pixel_locs) 

% This function aligns the spheroid centroids from the different days and finds
% - all the pixel points outside the day 0 boundary (the points of interest - POI)
% - Calculate the centroids for the connected components in the image 

%% Move the day 0 boundary to have the centroid in the day 3 image
%centered_boundary = [boundary(:,2), boundary(:,1)] - centroid_loc + centroid_loc3;
centered_boundary = boundary + centroid_loc2 - centroid_loc;


%% Find the pixel points outside of the centered boundary

%-- Includes a mask to filter out points that are too small to be actual cells

% poly_boundary = polyshape(day3centered_boundary(:,2), day3centered_boundary(:,1));
poly_boundary = polyshape(centered_boundary(:,1), centered_boundary(:,2));
%outside_pixel_loc = cell(length(blob_centroids), 1);
%outer_pixels2 = cell(length(blob_centroids), 1);

disp('Determining blobs outside of boundary')
outer_blobs_index = ~isinterior(poly_boundary, blob_centroids);
outer_blobs = blob_centroids(outer_blobs_index,:);

% for i = 1:length(boundary_pixel_locs)
% 
%     fprintf(' Index %i out of %i\n', i, length(blob_centroids))
% 
%     %Determine points not in boundary: analyze the element edges first
%     %if all(boundary_pixel_locs{i} == 0) || all(boundary_pixel_locs{i} == 1)
%         %outside_pixel_loc{i} = ~isinterior(poly_boundary, boundary_pixel_locs{i}); 
%     if all(~isinterior(poly_boundary, boundary_pixel_locs{i}))
%         %centroid_list_size = size(blob_centroids);
%         outside_blob_loc(i) = logical(ones(centroid_list_size(1),1));
%         %disp('outside') % - for debugging purposes
%     elseif all(isinterior(poly_boundary, boundary_pixel_locs{i}))
%         %disp('inside') % - for debugging purposes
%     else
%         %disp('determining') % - for debugging purposes
%         for j = 1:length(boundary_pixel_locs{i})
%             outside_blob_loc{i} = ~isinterior(poly_boundary, blob_centroids{i}); 
%         end
% 
%     end
% 
%     outer_pixels2{i} = blob_centroids{i}(outside_blob_loc{i},:);
% 
%     areas_mask = areas>5;
%     total_masked = logical(areas_mask.*outside_pixel_loc{i}); %logical makes it a booleans so that we can index with it
%     outer_pixels3 = pixel_locs{i}(total_masked,:);
%     areas_filtered = areas(total_masked);      
% 
% end 


% %Remove the empty components from the cell (these are from the interior
% %pixels)
% outer_pixels2 = outer_pixels2(~cellfun('isempty', outer_pixels2'));



%% Plot the points over the images

% % Double checking that the poly boundary and the actual boundary points are
% % the same thing
% figure
% plot(poly_boundary)
% hold on
% %plot(day3centered_boundary(:,2), day3centered_boundary(:,1), 'g', 'LineWidth', 3);
% plot(day3centered_boundary(:,1), day3centered_boundary(:,2), 'g', 'LineWidth', 3);
% hold off
% title ('Are the boundary points and polyline the same?')


% Display the binary images with the uncentered and centered boundaries

% 
figure
imshow(binary_image)
hold on
% plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 3);
plot(boundary(:,1), boundary(:,2), 'g', 'LineWidth', 3);
plot(centroid_loc(1), centroid_loc(2), 'g*')
plot(centroid_loc2(1), centroid_loc2(2), 'b*')
hold off
title('uncentered boundary')


figure
imshow(binary_image)
hold on
plot(centered_boundary(:,1), centered_boundary(:,2), 'g', 'LineWidth', 3);
plot(centroid_loc2(1), centroid_loc2(2), 'b*')
title('centered boundary and outer blobs')
plot(outer_blobs(:,1), outer_blobs(:,2), 'c*')



% for i = 1:length(outer_pixels2)
%     if isempty(outer_pixels2{i})
%         continue
%     else
%         plot(outer_pixels2{i}(:,1),outer_pixels2{i}(:,2), 'c.')
%         %plot(outer_pixels3{i}(:,1),outer_pixels3{i}(:,2), '.') %for debugging
%     end 
% end

%     %Display and superimpose the outside pixel locations on the binary image
%     plot(outer_pixels3{i}(:,1),outer_pixels3{i}(:,2), '.')
% 
%     %Try a faster plotting method - plot random fewer numbers
%     if isempty(outer_pixels3{i})
%         continue
%     else
%         r_xmin = min(outer_pixels3{i}(:,1));
%         r_ymin = min(outer_pixels3{i}(:,2));
%         r_xmax = max(outer_pixels3{i}(:,1));
%         r_ymax = max(outer_pixels3{i}(:,2));
%         rand_xpixels = randi([r_xmin r_xmax], [1,5]);
%         rand_ypixels = randi([r_ymin r_ymax], [1,5]);
%         
%         plot(rand_xpixels,rand_ypixels, '.')
%     end

hold off



disp('end of function')


end