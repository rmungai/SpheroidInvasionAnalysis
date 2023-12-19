%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; April 2022

function [distance_magnitude, distance_x, distance_y, horizontal_line] = PixelDistancetoCenter(outer_pixels3, ...
    spheroid_centroid, binary_image, boundary)
%This function calculates the distances of the outer pixels from the main spheroid centroid and plots them.
%   Calculates the magnitude and slopes of the distance lines and plots them over the 
%   binarized image 

distance_magnitude = cell(length(outer_pixels3),1);
m = cell(length(outer_pixels3),1);
b = cell(length(outer_pixels3),1);

disp('Determining distances to center')

%Calculate distances one element at a time
for i = 1:length(outer_pixels3)

    %Distance formula: distances = sqrt((x - x_center).^2 + (y - y_center).^2);
    distance_magnitude{i} = sqrt( (outer_pixels3{i}(:,2)-spheroid_centroid(:,2)).^2 + (outer_pixels3{i}(:,1)-spheroid_centroid(:,1)).^2 );
    
    % Find slope of the lines
    % m = (y2-y1)/(x2-x1)
    m{i} = (outer_pixels3{i}(:,2)-spheroid_centroid(:,2)) ./ (outer_pixels3{i}(:,1)-spheroid_centroid(:,1));
    
    % Find the y-intercept of the line: y = mx+b  ->  b = y-mx
    b{i} = spheroid_centroid(:,2) - m{i}*spheroid_centroid(:,1);
    
    %fprintf('On index %i out of %i\n', i, length(outer_pixels3))

end



%Plot the lines over the binarized image
% --------plotting the distance lines using the regular plot function
%------- the distance array is (number of points making up the line, number of centroids)
%------- ex. distance_x(100, 1) and distance_x(1,1) are the ends of
%------- the line of the same centroid from the spheroid center

figure
imshow(binary_image)
hold on

distance_x = cell(length(outer_pixels3),1);
distance_y = cell(length(outer_pixels3),1);




distance_x = cell(length(outer_pixels3),1);
distance_y = cell(length(outer_pixels3),1);
num_points = 100;

for  i = 1:length(outer_pixels3)
    
%         if x_index(end) > size(binary_image,1)
%             x_index = x_index(1):size(binary_image,1);
%         end

    e_size = size(outer_pixels3{i},1);
    if e_size==0 %cautioning against empty cells
        continue;
    end
    %fprintf('On index %i out of %i\n', i, length(outer_pixels3))

    distance_xi = zeros(num_points, e_size);
    distance_yi = zeros(num_points, e_size);
    
    for p = 1:e_size
        distance_xi(:,p) = linspace(spheroid_centroid(1), outer_pixels3{i}(p, 1), num_points)';
        distance_yi(:,p) = m{i}(p) .* distance_xi(:,p) + b{i}(p);
    end

       
%     for i = 1:length(outer_pixels3)
%         distance_xi(:,i) = linspace(spheroid_centroid(1), outer_pixels3{j}(i, 1), num_points)';
%         distance_yi(:,i) = m{j}(i) .* distance_xi(:,i) + b{j}(i);
%     end

%     %remove any columns with all zeros from the array - dont need this
%     distance_xi=distance_xi(:,any(distance_xi));
%     distance_yi=distance_yi(:,any(distance_yi));

    %assign to cell
    distance_x{i} = distance_xyi;
    distance_y{i} = distance_yi;
    
%     %Plot all the distances on the image wo using the line() function 
%     %-- (plotting points)
%     plot(distance_xi, distance_yi, "b");

end



%Try a faster plotting method - plot random fewer numbers
lines = randi([1 210], [1,20]);
for j = 1:length(lines)
    plot(distance_x{lines(j)}(:,1), distance_y{lines(j)}(:,1), "b")
end

% %Plot just a few lines as an example
% plot(distance_x{8}(:,9), distance_y{8}(:,9), "b")
% plot(distance_x{156}(:,9), distance_y{156}(:,9), "b")
% plot(distance_x{50}(:,9), distance_y{50}(:,9), "b")
% plot(distance_x{210}(:,9), distance_y{210}(:,9), "b")
% plot(distance_x{30}(:,9), distance_y{30}(:,9), "b")
% plot(distance_x{180}(:,9), distance_y{180}(:,9), "b")

%Show the boundary on the image
plot(boundary(:,1), boundary(:,2), 'g', 'LineWidth', 3);
%plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 3);

%Add a horizontal line across the image
x = linspace(0,2000, num_points)';
% x = linspace(0,2000spheroid_centroid(1) - 1000, spheroid_centroid(1) + num_points*5, num_points)'; 
  %----------another way to define
y = linspace(spheroid_centroid(2), spheroid_centroid(2), num_points)';
horizontal_line = [x,y];
plot(x,y, 'r')
title('distances from center')
hold off



end



