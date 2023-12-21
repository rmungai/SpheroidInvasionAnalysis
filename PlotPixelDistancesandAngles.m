%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; April 2022

function [final_pixels, Irb, Ixb, Iyb,  Irc, Ixc, Iyc, max_dist, median_dist, mean_dist, speedum_array, angles_array] = PlotPixelDistancesandAngles(outer_distance_magnitude, ...
     outer_distances_xy, full_distance_magnitude, full_distances_xy, angles, num_days, pixel_size)
%This function reads in the outer centroid areas (filtered to remove small particles) as well as 
% their distances to the boundary and the angles from a horizontal line.
% distx: distance value from center of spheroid to the migrating cell in x-direction
% disty: distance value from center of spheroid to the migrating cell in x-direction
% The function plots those values 


%% Distance values ------------------------------------------

outerdistance_lengths = outer_distance_magnitude{1};
for i = 2:length(outer_distance_magnitude)
    outerdmag_array_i = outer_distance_magnitude{i};
    outerdistance_lengths = [outerdistance_lengths; outerdmag_array_i];
end

centerdistance_lengths = full_distance_magnitude{1};
for i = 2:length(full_distance_magnitude)
    centerdmag_array_i = full_distance_magnitude{i};
    centerdistance_lengths = [centerdistance_lengths; centerdmag_array_i];
end


%Plot distances in a histogram
figure
subplot (2,1,1)
%- histogram(outer_distance_magnitude,20)
h1 = histogram(outerdistance_lengths,20);
title ('Distances from boundary histogram')
xlabel('distance (pixels)')
ylabel('frequency')
set(gca,'Fontname','arial', 'FontSize',14);

%Plot the cumulative values in a histogram -----------------------------
subplot(2,1,2)
x = 50:50:1000;
cumDistValues = cumsum(h1.Values);
bar(x, cumDistValues)
title('Cumulative distances from boundary histogram')
xlabel('distance (pixels)')
ylabel('frequency')
set(gca,'Fontname','arial', 'FontSize',14);

%cdfplot(final_centroids(:,2)) %< - perhaps another option


%Plot the angle values in a rose plot -----------------------------------
angles_array = angles{1};
for i = 2:length(angles)
    angles_array_i = angles{i};
    angles_array = [angles_array; angles_array_i];
end

% - convert angles to radians
angles_array = deg2rad(angles_array);


figure
% - polarhistogram(angles, 20)
polarhistogram(angles_array, 20);
title('Angles histogram')
set(gca,'Fontname','arial', 'FontSize',14);

%Plot the max, median and mean distances from the boundary in a bar graph--------------
max_dist = max(outerdistance_lengths);
median_dist = median(outerdistance_lengths);
mean_dist = mean(outerdistance_lengths);

figure
x = categorical({'max', 'median', 'mean'});
x = reordercats(x,{'max', 'median', 'mean'});
y = [max_dist, median_dist, mean_dist];
bar(x, y)

title('Representative distance values from the boundary')
ylabel('distance (pixels)')
set(gca,'Fontname','arial', 'FontSize',14);

%Add values on top of the bars
labels = {num2str(ceil(max_dist)), num2str(ceil(median_dist)), num2str(ceil(mean_dist)) };
xt = get(gca, 'XTick');
text(xt, y, labels, 'HorizontalAlignment','center', 'VerticalAlignment','bottom')



% Plot the distances from center vs angle values in a polar plot-----------
figure
polarplot(angles_array, centerdistance_lengths,'.')
title (["Distances from spheroid center (pixels) vs","migration angle"])

% - Set figure size: 
% - https://www.mathworks.com/help/matlab/ref/figure.html#buich1u-1_sep_shared-Position
set(gca,'Fontname','arial', 'FontSize',14, 'OuterPosition', [0 0.2 1 0.75]);

%Plot the boundary distance vs angle values in a polar plot-----------------
figure 
polarplot(angles_array, outerdistance_lengths,'.')
title (["Distances from spheroid boundary (pixels) vs ","migration angle"])

% - Set figure size: 
% - https://www.mathworks.com/help/matlab/ref/figure.html#buich1u-1_sep_shared-Position
set(gca,'Fontname','arial', 'FontSize',14, 'OuterPosition', [0 0.2 1 0.75]);



%% Persistance speed (um/min) from boundary
 

%speed = outer_distance_magnitude/num_days;
speed = cell(length(outer_distance_magnitude),1);
speed_um = cell(length(outer_distance_magnitude),1);
for i = 1:length(outer_distance_magnitude)
    speed{i} = outer_distance_magnitude{i} / (num_days*24*60); 
    speed_um{i} = speed{i}.*pixel_size;
end

outerdistance_lengths_um = (outerdistance_lengths)*pixel_size;
centerdistance_lengths_um = (centerdistance_lengths)*pixel_size;
speedum_array = (outerdistance_lengths_um) / (num_days*24*60); %um/min


% speed_array = speed{1};
% for i = 2:length(speed)
%     speed_array_i = speed{i};
%     speed_array = [speed_array; speed_array_i];
% end
% 
% figure
% polarplot(angles_array, speed_array, '.') 
% title ('Persistance speed (pixels/min) vs migration angle')


% speedum_array = speed_um{1};
% for i = 2:length(speed_um)
%     speedum_array_i = speed_um{i};
%     speedum_array = [speedum_array; speedum_array_i];
% end


%Plot the persistant speed vs angle values in a polar plot----------------
%---essentially the same as distance plot
figure
polarplot(angles_array, speedum_array, '.') 
title ('Persistence speed (um/min) vs migration angle')

%Set figure size: 
% - https://www.mathworks.com/help/matlab/ref/figure.html#buich1u-1_sep_shared-Position
set(gca,'Fontname','arial', 'FontSize',14, 'OuterPosition', [0 0.2 1 0.75]);


% for i = 1:length(outer_pixels)
%     plot(outer_pixels{i}(:,1),outer_pixels{i}(:,2), 'b.', 'LineWidth', 3)
%     plot(boundary_intersect{i}(:,1), boundary_intersect{i}(:,2), 'rx', 'LineWidth', 3)
%     %plot(mxb, myb, 'rx', 'LineWidth', 3)
%     for j = 1:200:length(outer_pixels{i}(:,1))
%         %plot([centroid_loc(1), outer_pixels{i}(j,1)], [centroid_loc(2), outer_pixels{i}(j,2)], 'c')
%         plot([boundary_intersect{i}(j,1), outer_pixels{i}(j,1)], [boundary_intersect{i}(j,2), outer_pixels{i}(j,2)], 'c')
%     end
%     plot(centroid_loc(1), centroid_loc(2), 'rx', 'LineWidth', 3)
% end


% %Plot the angle values in a histogram -----------------------------------
% figure
% subplot(2,1,1)
% % - histogram(angles,20)
% histogram(final_centroids_um(:,3),20);
% title('Angles histogram')
% xlabel('angles (degrees)')
% ylabel('frequency')
% xticks(0:45:360);
% 
% %Plot the persistant speed vs angle values as points -------------------------
% %subplot(2,1,2)
% % - plot(outer_distance_magnitude/num_days, areas_filtered)
% scatter(final_centroids_um(:,3), speed_um) 
% title ('Persistance speed vs migration angle')
% xlabel('angle (degrees)')
% ylabel('speed (um/min)')
% xlim([0 360])
% xticks(0:45:360);
% grid on




% %///////////////////////////////////////////////////////////////////////
%///////////////////////////////////////////////////////////////////////
%Calculate the area moment of inertia from the boundary ---------------
% - Iro = sum((outer_distance_mag)^2 * 1):
% - - - polar movement from boundary
% - Ixo = sum((outer_distance_y)^2 * 1):
%  - - - y-dir movement from x axis from boundary
% - Iyo = sum((outer_distance_x)^2 * 1):
% - - - x-dir movement from y-axis from boundary


outer_distances_xy_array = outer_distances_xy{1};
for i = 2:length(outer_distances_xy)
    outer_distances_xy_array_i = outer_distances_xy{i};
    outer_distances_xy_array = [outer_distances_xy_array; outer_distances_xy_array_i];
end 


a = 1; %area for calculation - in this case = 1 bc pixels
disp('Area Moment of Inertia values Ix and Iy from spheroid boundary:')
Irb = sum(outerdistance_lengths.^2 * a)
Ixb = sum(outer_distances_xy_array(:,2).^2 * a)
Iyb = sum(outer_distances_xy_array(:,1).^2 * a)


%Calculate the area moment of inertia from the spheroid center-----------------
% - Ir = sum((distance_mag)^2 * 1); polar movement from center
% - Ix = sum((distance_y)^2 * 1); y-dir movement from x axis
% - Iy = sum((distance_x)^2 * 1); x-dir movement from y-axis

full_distances_xy_array = full_distances_xy{1};
for i = 2:length(full_distances_xy)
    full_distances_xy_array_i = full_distances_xy{i};
    full_distances_xy_array = [full_distances_xy_array; full_distances_xy_array_i];
end 


a = 1; %area for calculation - in this case = 1 bc pixels
disp('Area Moment of Inertia values Ix and Iy from spheroid center:')
Irc = sum(centerdistance_lengths.^2 * a)
Ixc = sum(full_distances_xy_array(:,2).^2 * a)
Iyc = sum(full_distances_xy_array(:,1).^2 * a)





%Plot the moment of inertia values in a bar graph--------------
% - Moment from Spheroid Center .....................
figure
x = categorical({'Ir', 'Ix', 'Iy'});
x = reordercats(x,{'Ir', 'Ix', 'Iy'});
y = [Irc, Ixc, Iyc];
bar(x, y)

title('Moment of inertia from spheroid center')
ylabel('Moment (pixels^4)')
set(gca,'Fontname','arial', 'FontSize',14);

%Add values on top of the bars
labels = {sprintf('%.2e',Irc), sprintf('%.2e',Ixc), sprintf('%.2e',Iyc) };
xt = get(gca, 'XTick');
text(xt, y, labels, 'HorizontalAlignment','center', 'VerticalAlignment','bottom')

% - Moment from Spheroid Boundary .....................
figure
x = categorical({'Ir', 'Ix', 'Iy'});
x = reordercats(x,{'Ir', 'Ix', 'Iy'});
y = [Irb, Ixb, Iyb];
bar(x, y)

title('Moment of inertia from spheroid boundary')
ylabel('Moment (pixels^4)')
set(gca,'Fontname','arial', 'FontSize',14);

%Add values on top of the bars
labels = {sprintf('%.2e',Irb), sprintf('%.2e',Ixb), sprintf('%.2e',Iyb) };
xt = get(gca, 'XTick');
text(xt, y, labels, 'HorizontalAlignment','center', 'VerticalAlignment','bottom')


% distance_xy = zeros(length(full_distances_xy),2); %the lengths of the x and y distances
% for i = 1:length(full_distances_xy)
%     distance_xy(i,1) = abs(full_distances_xy{i}(100,:) - full_distances_xy{i}(100,:));
%     distance_xy(i,2) = abs(disty{i}(100,:) - disty{i}(1,:));
% end 
% 
% a = 1; %area for calculation - in this case = 1 bc pixels
% disp('Area Moment of Inertia values Ix and Iy:')
% Ix = sum(distance_xy(:,1).^2 * a)
% Iy = sum(distance_xy(:,2).^2 * a)




final_pixels = table(outer_distance_magnitude, outer_distances_xy, full_distance_magnitude, full_distances_xy, speed, speed_um, angles);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Plot both in one frequency histogram
% figure
% histogram(Ix,20);
% title ('Area moment of inertia')
% xlabel('Area moment of inertia (um)^4')
% ylabel('frequency')
% hold on
% histogram(Iy,20);
% legend('Ix', 'Iy');
% hold off

% %Plot area moment of inertia vs angles (nevermind this)
% figure
% % - plot(angles, Ix)
% %scatter(final_centroids(:,3), Ix);
% semilogy(final_pixels(:,3), Ix, 'o'); 
% hold on
% 
% %scatter(final_centroids(:,3), Iy);
% semilogy(final_pixels(:,3), Iy, 'o');
% legend('Ix','Iy');
% title ('Area moment of inertia vs migration angle')
% xlabel('angle (degrees)')
% ylabel('Area moment of inertia (um)^4')
% 
% xlim([0 360])
% xticks(0:45:360);
% %set(gca, 'YScale', 'log') %<- use if using "scatter" to make Y-axis log
% grid on
% hold off



% %Plot separate frequecy histograms
% figure
% subplot (2,1,1)
% h3 = histogram(Ix,20);
% title ('Area moment of inertia about x')
% xlabel('Ix')
% ylabel('frequency')
% 
% subplot(2,1,2)
% h4 = histogram(Iy,20);
% title ('Area moment of inertia about y')
% xlabel('Iy')
% ylabel('frequency')


%////////////////////////////////////////////////////////////////////



% % Example of how to append to an array:
% % - Takes the value of the previous index and adds two to get the value for
% % - the next index
%  A = zeros(1,4);
%  A(1) = 1;
%  for i = 2:4
%     A(i) = A(i-1) + 2; 
%  end
%  % - Now add an extra row to the array
%  A(end+1) = 16;
 



end

