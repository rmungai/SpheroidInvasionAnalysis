function [angles] = FindBlobAngles(binary_image, outer_centroids, centroid_loc, distances_xy, boundary, horizontal_line)
%This function calculates the angles of the centroids from the horizontal line as a reference
%   Angles range from 0 - 360 degrees and is organized like the unit circle. 
%   The arc tangent function is used to calculate the angle

disp('Determining angles')

%Show the binary image
figure
imshow(binary_image)
hold on

%POI = [1,400,100,385]; %centroids of interest (POI)
angles = zeros(length(outer_centroids),1);

for i = 1:length(outer_centroids)

        
        %Calculate the adjecent and opposite distances to the angle of interest
        adj = distances_xy(i,1);
        opp = -distances_xy(i,2); 
    
        %Use them to calculate the angle using arctangent
        % - The image is oriented with the origin in the top left
        % - The if statements accomodate for this 
        if opp<0 & adj>0
            %disp('Quadrant 4')
            angle = 360 + atand(opp/adj);
        elseif opp<0 & adj<0
            %disp('Quadrant 3')
            angle = 180 + atand(opp/adj);
        elseif opp>0 & adj<0
            %disp('Quandrant 2')
            angle = atand(opp/adj) + 180;
        else
            %disp('Quadrant 1')
            angle = atand(opp/adj); 
        end 
        
        %Add value to array
        angles(i) = angle;

%         %Plot the lines
%         plot(distance_x{i}(:,p), distance_y{i}(:,p)); 
        
  
end

plot([centroid_loc(1), outer_centroids(round((3/4)*end), 1)], [centroid_loc(2), outer_centroids(round((3/4)*end), 2)])
plot([centroid_loc(1), outer_centroids(round(end-1), 1)], [centroid_loc(2), outer_centroids(round(end-1), 2)])
plot([centroid_loc(1), outer_centroids(round((1/4)*end), 1)], [centroid_loc(2), outer_centroids(round((1/4)*end), 2)])
plot([centroid_loc(1), outer_centroids(round(end/2) ,1)], [centroid_loc(2), outer_centroids(round(end/2), 2)])

% plot([centroid_loc(1), outer_centroids{round((3/4)*end)}(end,1)], [centroid_loc(2), outer_centroids{round((3/4)*end)}(end,2)])
% plot([centroid_loc(1), outer_centroids{end-1}(end,1)], [centroid_loc(2), outer_centroids{end-1}(end,2)])
% plot([centroid_loc(1), outer_centroids{round((1/4)*end)}(end,1)], [centroid_loc(2), outer_centroids{round((1/4)*end)}(end,2)])
% plot([centroid_loc(1), outer_centroids{round(end/2)}(end,1)], [centroid_loc(2), outer_centroids{round(end/2)}(end,2)])


title("angles of migration in degrees")
legend( [num2str(round(angles(round((3/4)*end)))), char(176)], ...
    [num2str(round(angles(round(end-1)))),  char(176)],...
    [num2str(round(angles(round((1/4)*end)))),  char(176)], ...
    [num2str(round(angles(round(end/2)))), char(176)] )

%Show the boundary and horizontal line on the image
plot(boundary(:,1), boundary(:,2), 'g', 'LineWidth', 3);
plot([horizontal_line(1,1), horizontal_line(2,1)],[horizontal_line(1,2), horizontal_line(2,2)], 'r')

hold off

end

