function [outer_distance_magnitude, outer_distances_xy, full_distance_magnitude, full_distances_xy, ...
    boundary_intersect, horizontal_line] = CalculateDistances(outer_pixels, centroid_loc, boundary, binary_image)
%FindDistanceFromLine finds the minnimum distance from target_point to the
% line defined by linePointOne and zeroPoint. The functions zeros the
% coordinate system at zeroPoint. Each point should be aranged as
% point = [x_loc; y_loc]
%   Detailed explanation goes here --outerpixels here is given as one cell
%   at a time

%% The full distance
%Calculate the full distances
full_distance_magnitude = cell(length(outer_pixels),1);
full_distances_xy = cell(length(outer_pixels),1);
for i = 1:length(outer_pixels) 
    full_distances_xy{i}(:,1) = outer_pixels{i}(:,1) - centroid_loc(1);
    full_distances_xy{i}(:,2) = outer_pixels{i}(:,2) - centroid_loc(2);
    
    %Distance formula: distances = sqrt((x - x_center).^2 + (y - y_center).^2);
    full_distance_magnitude{i} = sqrt( (outer_pixels{i}(:,2)-centroid_loc(:,2)).^2 + (outer_pixels{i}(:,1)-centroid_loc(:,1)).^2 );
       
end

figure
imshow(binary_image)
hold on

plot(centroid_loc(1), centroid_loc(2), 'b*', 'LineWidth', 3)
plot(boundary(:,1), boundary(:,2), 'g', 'LineWidth', 3)

for i = 1:length(outer_pixels)
    for j = 1:350:length(outer_pixels{i}(:,1))
        plot([centroid_loc(1), outer_pixels{i}(j,1)], [centroid_loc(2), outer_pixels{i}(j,2)], 'b')
    end    
end
%time_plot = toc

%Show the boundary on the image
plot(boundary(:,1), boundary(:,2), 'g', 'LineWidth', 3)

%Show the spheroid centroid
plot(centroid_loc(1), centroid_loc(2), 'g*', 'LineWidth', 3)

%Add a horizontal line across the image
x = [0,2000]';
y = [centroid_loc(2), centroid_loc(2)]';
horizontal_line = [x,y];
plot([horizontal_line(1,1), horizontal_line(2,1)],[horizontal_line(1,2), horizontal_line(2,2)], 'r')
title('distances from center')
hold off






%% The distance from the boundary
%Calculate and store the intersection of the boundary and the distance %%%%%%%%%%
%tic


%Initialize storage cells
outer_distance_magnitude = cell(length(outer_pixels), 1);
boundary_intersect = cell(length(outer_pixels), 1);
outer_distances_xy = cell(length(outer_pixels),1);

for i = 1:length(outer_pixels)

    %Calculate distance magnitude to boundary
    [od_magnitude, boundary_xint,boundary_yint] = IntersectionDistance(outer_pixels{i}, centroid_loc, boundary);
    outer_distance_magnitude{i,1} = od_magnitude;
    boundary_intersect{i} = [boundary_xint boundary_yint];
    
    %Calculate x-y- distances to boundary
    outer_distances_xy{i}(:,1) = outer_pixels{i}(:,1) - boundary_intersect{i}(:,1);
    outer_distances_xy{i}(:,2) = outer_pixels{i}(:,2) - boundary_intersect{i}(:,2);
    
end
%time_calc = toc


%Plot The distances from the boundary to the outerpixels (just a few of
%them for easier visualization)
%tic

figure
imshow(binary_image)
hold on;

for i = 1:length(outer_pixels)
    %plot(outer_pixels{i}(:,1),outer_pixels{i}(:,2), 'b.', 'LineWidth', 3)
    %plot(boundary_intersect{i}(:,1), boundary_intersect{i}(:,2), 'rx', 'LineWidth', 3) 
    for j = 1:275:length(outer_pixels{i}(:,1))
        plot([boundary_intersect{i}(j,1), outer_pixels{i}(j,1)], [boundary_intersect{i}(j,2), outer_pixels{i}(j,2)], 'c')
    end
end

plot(centroid_loc(1), centroid_loc(2), 'g*', 'LineWidth', 3)
plot(boundary(:,1), boundary(:,2), 'g', 'LineWidth', 3)
plot([horizontal_line(1,1), horizontal_line(2,1)],[horizontal_line(1,2), horizontal_line(2,2)], 'r')

title('distances from boundary')
hold off



end

