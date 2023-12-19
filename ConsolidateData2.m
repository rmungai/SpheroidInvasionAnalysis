%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; October 2022
% -------------------PART 3----------------------
%---------- USE ON QUANTIFIED DATA ------------
% Consolidate the spheroid data for one expt to cells and arrays

%clear ; clc; close all

%% CONSOLIDATE SPHEROID DATA INTO CELLS AND ARRAYS 

myvars = who;
Variables_Cell = cell(length(myvars),2);
Variables_Cell(:,1) = myvars;
for i = 1:length(Variables_Cell)
    Variables_Cell(i,2) = {eval(sprintf('%1$s', myvars{i}))};
end


Variables_Cell2 = Variables_Cell;
for i = 1:length(Variables_Cell)
    j = Variables_Cell{i,2};
    Variables_Cell2(i,2) = {deleteoutliers(j)};
end






%% Creating arrays and cells to hold the values from the spheroids --------

%% Step 1: ---------------------------------------
% USER INPUT: load the variables from the first spheroid

% RUN FOLLOWING COMMANDS to reassign values new names and/or new structures
% - Each angle and speed value corresponds to one pixel

static_angles = {angles_array};
static_speeds = {speedum_array};

day0_areas = sum(areas);
day2_areas = sum(areas2);
static_day0areas = day0_areas;
static_day2areas = day2_areas;

Irb_static = Irb; Irc_static = Irc;
Ixb_static = Ixb; Ixc_static = Ixc;
Iyb_static = Iyb; Iyc_static = Iyc;

static_max_distances = max_distance;
static_mean_distances = mean_distance;
static_median_distances = median_distance;


%% Step 2: ---------------------------------------
% USER INPUT: load the variables from the next spheroids 

% RUN FOLLOWING COMMANDS to append values from the other spheroids
static_angles{end+1} = angles_array;
static_speeds{end+1} = speedum_array;

day0_areas = sum(areas);
day2_areas = sum(areas2);
static_day0areas = [static_day0areas, day0_areas];
static_day2areas = [static_day2areas, day2_areas];

Irb_static = [Irb_static, Irb]; Irc_static = [Irc_static, Irc];
Ixb_static = [Ixb_static, Ixb]; Ixc_static = [Ixc_static, Ixc];
Iyb_static = [Iyb_static, Iyb]; Iyc_static = [Iyc_static, Iyc];

static_max_distances = [static_max_distances, max_distance];
static_mean_distances = [static_mean_distances, mean_distance];
static_median_distances = [static_median_distances, median_distance];


% Clear un-needed variables from the workspace
clear angles_array speedum_array
clear areas areas2 day0_areas day2_areas
clear Irc Ixc Iyc Irb Ixb Iyb final_pixels
clear max_distance mean_distance median_distance




%% Step 3: ------
% USER INPUT: save the workspace variables


