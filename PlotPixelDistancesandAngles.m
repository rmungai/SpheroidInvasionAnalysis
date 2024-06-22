%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; April 2022

function [final_pixels, Irb, Ixb, Iyb,  Irc, Ixc, Iyc, max_dist, median_dist, mean_dist, outerdistance_lengths_um, ...
    angles_array] = PlotPixelDistancesandAngles(outer_distance_magnitude, outer_distances_xy, full_distance_magnitude, full_distances_xy, angles, outer_areas2, pixel_size)
%This function reads in the outer centroid areas (filtered to remove small particles) as well as 
% their distances to the boundary and the angles from a horizontal line.
% distx: distance value from center of spheroid to the migrating cell in x-direction
% disty: distance value from center of spheroid to the migrating cell in x-direction
% The function plots those values in the desired units (using the given pixel_size) and
% outputs the variables in units of pixels or, in the case of speed, microns.


%% Distance values ------------------------------------------

% %Comment out if these are already arrays
% outerdistance_lengths = outer_distance_magnitude{1};
% for i = 2:length(outer_distance_magnitude)
%     outerdmag_array_i = outer_distance_magnitude{i};
%     outerdistance_lengths = [outerdistance_lengths; outerdmag_array_i];
% end
% 
% centerdistance_lengths = full_distance_magnitude{1};
% for i = 2:length(full_distance_magnitude)
%     centerdmag_array_i = full_distance_magnitude{i};
%     centerdistance_lengths = [centerdistance_lengths; centerdmag_array_i];
% end

%Uncomment if they are already arrays
outerdistance_lengths = outer_distance_magnitude;
centerdistance_lengths = full_distance_magnitude;



%Calculate distances in microns
outerdistance_lengths_um = (outerdistance_lengths)*pixel_size;
centerdistance_lengths_um = (centerdistance_lengths)*pixel_size;


% Plot distances in a histogram  -----------------------------

% - histogram of distances from the boundary
figure
subplot (2,1,1)
%- histogram(outer_distance_magnitude,20)
h1 = histogram(outerdistance_lengths_um,20);
title ('Distances from boundary histogram')
xlabel('distance (um)')
ylabel('frequency')
set(gca,'Fontname','arial', 'FontSize',14);

% - calculate the bin centers
bin_centers = (h1.BinEdges(1:end-1) + h1.BinEdges(2:end)) / 2;

% histogram of cumulative distances from the boundary
subplot(2,1,2)
cumDistValues = cumsum(h1.Values);
bar(bin_centers, cumDistValues)
title('Cumulative distances from boundary histogram')
xlabel('distance (um)')
ylabel('frequency')
set(gca,'Fontname','arial', 'FontSize',14);



%Plot the angle values in a rose plot -----------------------------------

% % Comment out if angles is already an array
% angles_array = angles{1};
% for i = 2:length(angles)
%     angles_array_i = angles{i};
%     angles_array = [angles_array; angles_array_i];
% end
angles_array = angles; %Uncomment if angles is alreeady an array

% - convert angles to radians
angles_array = deg2rad(angles_array);


figure
polarhistogram(angles_array, 20);
title('Angles histogram')
set(gca,'Fontname','arial', 'FontSize',14);


% Plot the max, median and mean distances from the boundary in a bar graph--------------
max_dist = max(outerdistance_lengths_um);
median_dist = median(outerdistance_lengths_um);
mean_dist = mean(outerdistance_lengths_um);

figure
x = categorical({'max', 'median', 'mean'});
x = reordercats(x,{'max', 'median', 'mean'});
y = [max_dist, median_dist, mean_dist];
bar(x, y)

title('Representative distance values from the boundary')
ylabel('distance (um)')
set(gca,'Fontname','arial', 'FontSize',14);

% - add values on top of the bars
labels = {num2str(ceil(max_dist)), num2str(ceil(median_dist)), num2str(ceil(mean_dist)) };
xt = get(gca, 'XTick');
text(xt, y, labels, 'HorizontalAlignment','center', 'VerticalAlignment','bottom')



%% Plot distance from center and boundary (mm)

% Plot the distances from center vs angle values in a polar plot-----------
figure
polarplot(angles_array, centerdistance_lengths_um/1e3,'*')
title (["Distances from spheroid center (mm) vs","migration angle"])

% - Set figure size: 
% - https://www.mathworks.com/help/matlab/ref/figure.html#buich1u-1_sep_shared-Position
set(gca,'Fontname','arial', 'FontSize',14, 'OuterPosition', [0 0.2 1 0.75]);


%Plot the boundary distance vs angle values in a polar plot-----------------
figure 
polarplot(angles_array, outerdistance_lengths/1e3,'*')
title (["Distances from spheroid boundary (mm) vs ","migration angle"])
set(gca,'Fontname','arial', 'FontSize',14, 'OuterPosition', [0 0.2 1 0.75]);



% %% Persistance speed (um/min) from boundary
% % - If desired as an output, add to function call
% 
% %speed = outer_distance_magnitude/num_days;
% speed = cell(length(outer_distance_magnitude),1);
% speed_um = cell(length(outer_distance_magnitude),1);
% for i = 1:length(outer_distance_magnitude)
%     speed{i} = outer_distance_magnitude{i} / (num_days*24*60); 
%     speed_um{i} = speed{i}.*pixel_size;
% end
% 
% speedum_array = (outerdistance_lengths_um) / (num_days*24*60); %um/min
% 
% 
% %Plot the persistant speed vs angle values in a polar plot----------------
% %---essentially the same as distance plot
% figure
% polarplot(angles_array, speedum_array, '.') 
% title ('Persistence speed (um/min) vs migration angle')
% 
% %Set figure size: 
% % - https://www.mathworks.com/help/matlab/ref/figure.html#buich1u-1_sep_shared-Position
% set(gca,'Fontname','arial', 'FontSize',14, 'OuterPosition', [0 0.2 1 0.75]);





% %///////////////////////////////////////////////////////////////////////
%///////////////////////////////////////////////////////////////////////

%Set up the directional distances as arrays - - - - - - - - - - - - - - - 

% % - Comment out if the distances are already arrays
% outer_distances_xy_array = outer_distances_xy{1};
% for i = 2:length(outer_distances_xy)
%     outer_distances_xy_array_i = outer_distances_xy{i};
%     outer_distances_xy_array = [outer_distances_xy_array; outer_distances_xy_array_i];
% end 
% 
% 
% full_distances_xy_array = full_distances_xy{1};
% for i = 2:length(full_distances_xy)
%     full_distances_xy_array_i = full_distances_xy{i};
%     full_distances_xy_array = [full_distances_xy_array; full_distances_xy_array_i];
% end 

% - Uncomment if the distances are already arrays
outer_distances_xy_array = outer_distances_xy;
full_distances_xy_array = full_distances_xy;





%Calculate the area moment of inertia from the boundary [pixel units] ---------
% - Iro = sum((outer_distance_mag)^2 * (outer_areas) ):
% - - - polar movement from boundary
% - Ixo = sum((outer_distance_y)^2 * (outer_areas) ):
%  - - - y-dir movement from x axis from boundary
% - Iyo = sum((outer_distance_x)^2 * (outer_areas) ):
% - - - x-dir movement from y-axis from boundary

disp('Area Moment of Inertia values Ix and Iy from spheroid boundary:')
Irb = sum(outerdistance_lengths.^2 .* outer_areas2)
Ixb = sum(outer_distances_xy_array(:,2).^2 .* outer_areas2)
Iyb = sum(outer_distances_xy_array(:,1).^2 .* outer_areas2)


%Calculate the area moment of inertia from the spheroid center [pixel units] --------
% - Ir = sum((distance_mag)^2 * (outer_areas) ); polar movement from center
% - Ix = sum((distance_y)^2 * (outer_areas) ); y-dir movement from x axis
% - Iy = sum((distance_x)^2 * (outer_areas) ); x-dir movement from y-axis

disp('Area Moment of Inertia values Ix and Iy from spheroid center:')
Irc = sum(centerdistance_lengths.^2 .* outer_areas2)
Ixc = sum(full_distances_xy_array(:,2).^2 .* outer_areas2)
Iyc = sum(full_distances_xy_array(:,1).^2 .* outer_areas2)



% % Previous method for calculating the area moment of inertia for
% % the pixel-based quantification method
% % Calculate the area moment of inertia from the boundary in pixels ---------
% % - Iro = sum((outer_distance_mag)^2 * 1):
% % - - - polar movement from boundary
% % - Ixo = sum((outer_distance_y)^2 * 1):
% %  - - - y-dir movement from x axis from boundary
% % - Iyo = sum((outer_distance_x)^2 * 1):
% % - - - x-dir movement from y-axis from boundary
% outer_areas2
% a = 1; %area for calculation - in this case = 1 bc pixels
% disp('Area Moment of Inertia values Ix and Iy from spheroid boundary:')
% Irb = sum(outerdistance_lengths.^2 * a)
% Ixb = sum(outer_distances_xy_array(:,2).^2 * a)
% Iyb = sum(outer_distances_xy_array(:,1).^2 * a)
% 
% 
% % Calculate the area moment of inertia from the spheroid center in pixels --------
% % - Ir = sum((distance_mag)^2 * 1); polar movement from center
% % - Ix = sum((distance_y)^2 * 1); y-dir movement from x axis
% % - Iy = sum((distance_x)^2 * 1); x-dir movement from y-axis
% 
% a = 1; %area for calculation - in this case = 1 bc pixels
% disp('Area Moment of Inertia values Ix and Iy from spheroid center:')
% Irc = sum(centerdistance_lengths.^2 * a)
% Ixc = sum(full_distances_xy_array(:,2).^2 * a)
% Iyc = sum(full_distances_xy_array(:,1).^2 * a)





%Plot the moment of inertia values in a bar graph (mm^4)--------------
% - Moment from Spheroid Center .....................
figure
x = categorical({'Ir', 'Ix', 'Iy'});
x = reordercats(x,{'Ir', 'Ix', 'Iy'});
y = [Irc, Ixc, Iyc];
bar(x, y.*(pixel_size/1e3)^4)

title('Moment of inertia from spheroid center')
ylabel('Moment (mm^4)')
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
bar(x, y.*(pixel_size/1e3)^4)

title('Moment of inertia from spheroid boundary')
ylabel('Moment (mm^4)')
set(gca,'Fontname','arial', 'FontSize',14);

%Add values on top of the bars
labels = {sprintf('%.2e',Irb), sprintf('%.2e',Ixb), sprintf('%.2e',Iyb) };
xt = get(gca, 'XTick');
text(xt, y, labels, 'HorizontalAlignment','center', 'VerticalAlignment','bottom')


final_pixels = table(outer_distance_magnitude, outer_distances_xy, full_distance_magnitude, full_distances_xy, angles);

end

