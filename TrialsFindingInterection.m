function [distance_magnitude,boundary_xint,boundary_yint] = DistancetoBoundaryFast(outer_pixels, centroid_loc, boundary)
%FindDistanceFromLine finds the minnimum distance from target_point to the
% line defined by linePointOne and zeroPoint. The functions zeros the
% coordinate system at zeroPoint. Each point should be aranged as
% point = [x_loc; y_loc]
%   Detailed explanation goes here --outerpixekls here is given as one cell
%   at a time


%Here I am trying to find the intersection of the boundary and the distance %%%%%%%%%%





%% A third attempt - Using a new function FindDistanceFromLine
tic
lines = cell(length(outer_pixels3), 2);
disp('Looping through elements now')
for i = 1:length(outer_pixels3)
    %fprintf('On index %i out of %i\n', i, length(outer_pixels3))

    %Testing function FIndingDistancesFromLine
    [dm, mxb, myb] = IntersectionDistance(outer_pixels3{i}, centroid_loc3, day3centered_boundary);
    lines{i,1} = mxb; lines{i,2} = myb;
end
time_calc = toc


%Plot
tic

figure
imshow(BW_3)
hold on;
plot(day3centered_boundary(:,1), day3centered_boundary(:,2), 'g', 'LineWidth', 3)

for i = 1:length(outer_pixels3)
    plot(outer_pixels3{i}(:,1),outer_pixels3{i}(:,2), 'b.', 'LineWidth', 3)
    plot(lines{i,1}, lines{i,2}, 'rx', 'LineWidth', 3)
    %plot(mxb, myb, 'rx', 'LineWidth', 3)
    for j = 1:100:length(outer_pixels3{i}(:,1))
        plot([centroid_loc3(1), outer_pixels3{i}(j,1)], [centroid_loc3(2), outer_pixels3{i}(j,2)], 'c')
    end
    plot(centroid_loc3(1), centroid_loc3(2), 'rx', 'LineWidth', 3)
end
time_plot = toc
hold off




% % % % % Other attempts % % % % % % % % % % % % % % % % % % % % % % % % % 
% %% FIrst attempt - Looking at the exact points for an approximation
% % - Using just cell 1 to try it out
% [points, loc_boundary, loc_distance] = intersect(boundary, [distance_x{1}(:,1) distance_y{1}(:,1)], 'stable');
% 
% figure
% plot(poly_boundary)
% hold on
% plot(distance_x{1}(:,1), distance_y{1}(:,1), 'b.')
% plot(distance_x{1}(loc_distance(1),1), distance_y{1}(loc_distance(2),1),'rx')
% hold off
% 
% %^ It's not working because there aren't any points in common
% 
% 
% 
% %% Second Attempt: Trying to find the exact point through polyshapes and lines
% %l = line(distance_x{1},distance_y{1});
% [vertexid,boundaryid,ind] = nearestvertex(poly_boundary, distance_x{1}(end,1), distance_y{1}(end,1));
% 
% figure
% plot(poly_boundary)
% hold on
% plot(distance_x{1}(:,1), distance_y{1}(:,1), 'b.')
% plot(poly_boundary.Vertices(vertexid,1),poly_boundary.Vertices(vertexid,2),'r*')
% hold off
% 
% %^This only gives me the location on the boundary, not on the distance
% line




