%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; October 2022
% -------------------PART 3----------------------
%---------- USE ON QUANTIFIED DATA ------------
% Consolidate the spheroid data for one expt to describe population trends

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








%% Creating arrays and cells to hold the values from the STATIC spheroids --------

%% Step 1: ---------------------------------------
% USER INPUT: load the variables from the first static spheroid

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
% USER INPUT: load the variables from the next static spheroids 

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

% USER INPUT: save the workspace variables and clear all vars




%% Creating arrays and cells to hold the values from the DYNAMIC spheroids

%% Step 1: ---------------------------------------
% USER INPUT: load the variables from the first dynamic spheroid

% RUN FOLLOWING COMMANDS to reassign values new names and/or new structures

dynamic_angles = {angles_array};
dynamic_speeds = {speedum_array};

day0_areas = sum(areas);
day2_areas = sum(areas2);
dynamic_day0areas = day0_areas;
dynamic_day2areas = day2_areas;

Irb_dynamic = Irb; Irc_dynamic = Irc;
Ixb_dynamic = Ixb; Ixc_dynamic = Ixc;
Iyb_dynamic = Iyb; Iyc_dynamic = Iyc;

dynamic_max_distances = max_distance;
dynamic_mean_distances = mean_distance;
dynamic_median_distances = median_distance;



%% Step 2: ---------------------------------------
% USER INPUT: load the variables from the next dynamic spheroids 

% RUN FOLLOWING COMMANDS to apppend values from the other spheroids
dynamic_angles{end+1} = angles_array;
dynamic_speeds{end+1} = speedum_array;

day0_areas = sum(areas);
day2_areas = sum(areas2);
dynamic_day0areas = [dynamic_day0areas, day0_areas];
dynamic_day2areas = [dynamic_day2areas, day2_areas];

Irb_dynamic = [Irb_dynamic, Irb]; Irc_dynamic = [Irc_dynamic, Irc];
Ixb_dynamic = [Ixb_dynamic, Ixb]; Ixc_dynamic = [Ixc_dynamic, Ixc];
Iyb_dynamic = [Iyb_dynamic, Iyb]; Iyc_dynamic = [Iyc_dynamic, Iyc];

dynamic_max_distances = [dynamic_max_distances, max_distance];
dynamic_mean_distances = [dynamic_mean_distances, mean_distance];
dynamic_median_distances = [dynamic_median_distances, median_distance];


% Clear un-needed variables from the workspace
clear angles_array speedum_array
clear areas areas2 day0_areas day2_areas
clear Irc Ixc Iyc Irb Ixb Iyb final_pixels
clear max_distance mean_distance median_distance

%% USER INPUT: save the workspace variables


% (!) USER INPUT: Make sure to also save a copy of the compiled dynamic and static variables




% % OLD METHOD FOR COMPILING STATIC VALUES-- KEEP COMMENTED OUT UNLESS NEEDED
% 
% % - Each angle and speed value corresponds to one pixel
% static_angles = {angles_array_sph1_static, angles_array_sph2_static, angles_array_sph3_static};
% static_speeds = {speedum_array_sph1_static, speedum_array_sph2_static, speedum_array_sph3_static};
% 
% static_day0areas = {areas_day0_sph1_static, areas_day0_sph2_static, areas_day0_sph3_static};
% static_day2areas = {areas_day2_sph1_static, areas_day2_sph2_static, areas_day2_sph3_static};
% 
% Ir_static = [Ir_sph1_static, Ir_sph2_static, Ir_sph3_static];
% Ix_static = [Ix_sph1_static, Ix_sph2_static, Ix_sph3_static];
% Iy_static = [Iy_sph1_static, Iy_sph2_static, Iy_sph3_static];
% 
% static_max_distances = {max_distance_sph1_static, max_distance_sph2_static, max_distance_sph3_static};
% static_mean_distances = {mean_distance_sph1_static, mean_distance_sph2_static, mean_distance_sph3_static};
% static_median_distances = {median_distance_sph1_static, median_distance_sph2_static, median_distance_sph3_static};

% ----------------------------------------------------------
