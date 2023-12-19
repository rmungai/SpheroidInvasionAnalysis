%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; October 2022
% -------------------PART 4----------------------
%---------- USE ON COMPILED QUANTIFIED DATA ------------
% Compile results on consilidated data for multiple experiments for one cell type

%clear ; clc; close all

%% (!) USER INPUT: load the compiled dynamic and static variables for first
% expt

% RUN FOLLOWING COMMANDS to reorganize data and compile data for experiments

% Find change in spheroid area
dday2areas = (dynamic_day2areas - dynamic_day0areas); 
ds_day2areas = (static_day2areas - static_day0areas);


% % Normalize the areas (fold change): (Y-X)/X
% nd_day2areas = (dynamic_day2areas - dynamic_day0areas) ./dynamic_day0areas; 
% ns_day2areas = (static_day2areas - static_day0areas) ./static_day0areas;


% Organize persistence speed data for each spheroid within experiment ----------------------------------
% --- static

static_max_speed = max(static_speeds{1});
static_mean_speed = mean(static_speeds{1});
static_median_speed = median(static_speeds{1});

for i = 2:size(static_speeds, 2)
    static_max_speed = [static_max_speed, max(static_speeds{i})];
    static_mean_speed = [static_mean_speed, mean(static_speeds{i})];
    static_median_speed = [static_median_speed, median(static_speeds{i})];
end

% ---dynamic
dynamic_max_speed = max(dynamic_speeds{1});
dynamic_mean_speed = mean(dynamic_speeds{1});
dynamic_median_speed = median(dynamic_speeds{1});

for i = 2:size(dynamic_speeds, 2)
    dynamic_max_speed = [dynamic_max_speed, max(dynamic_speeds{i})];
    dynamic_mean_speed = [dynamic_mean_speed, mean(dynamic_speeds{i})];
    dynamic_median_speed = [dynamic_median_speed, median(dynamic_speeds{i})];
end



% Organize distances for each spheroid within each expt ----------------------------------
% % --- static
% static_max_distances = cell2mat(static_max_distances);
% static_mean_distances = cell2mat(static_mean_distances);
% static_median_distances = cell2mat(static_median_distances);
% 
% % ---dynamic
% dynamic_max_distances = cell2mat(dynamic_max_distances);
% dynamic_mean_distances = cell2mat(dynamic_mean_distances);
% dynamic_median_distances = cell2mat(dynamic_median_distances);


% Organize angles data ----------------------------------
% --- static
static_max_angles = max(static_angles{1});
static_mean_angles = mean(static_angles{1});
static_median_angles = median(static_angles{1});

for i = 2:size(static_angles, 2)
    static_max_angles = [static_max_angles, max(static_angles{i})];
    static_mean_angles = [static_mean_angles, mean(static_angles{i})];
    static_median_angles = [static_median_angles, median(static_angles{i})];
end


% ---dynamic
dynamic_max_angles = max(dynamic_angles{1});
dynamic_mean_angles = mean(dynamic_angles{1});
dynamic_median_angles = median(dynamic_angles{1});

for i = 2:size(dynamic_angles, 2)
    dynamic_max_angles = [dynamic_max_angles, max(dynamic_angles{i})];
    dynamic_mean_angles = [dynamic_mean_angles, mean(dynamic_angles{i})];
    dynamic_median_angles = [dynamic_median_angles, median(dynamic_angles{i})];
end



%---- Initialize values for the first expt in cell group

Sareas = ds_day2areas;
Dareas = dday2areas;

S_speedmax = static_max_speed;
S_speedmedian = static_median_speed;
S_speedmean = static_mean_speed;

D_speedmax = dynamic_max_speed;
D_speedmedian = dynamic_median_speed;
D_speedmean = dynamic_mean_speed;

SIxb = Ixb_static; SIxc = Ixc_static;
SIyb = Iyb_static; SIyc = Iyc_static;
SIrb = Irb_static; SIrc = Irc_static;

DIxb = Ixb_dynamic; DIxc = Ixc_dynamic;
DIyb = Iyb_dynamic; DIyc = Iyc_dynamic;
DIrb = Irb_dynamic; DIrc = Irc_dynamic;


S_distmax = static_max_distances;
S_distmean = static_mean_distances;
S_distmedian = static_median_distances;

D_distmax = dynamic_max_distances;
D_distmean = dynamic_mean_distances;
D_distmedian = dynamic_median_distances;

S_anglesmax = static_max_angles;
S_anglesmean = static_mean_angles;
S_anglesmedian = static_median_angles;

D_anglesmax = dynamic_max_angles;
D_anglesmean = dynamic_mean_angles;
D_anglesmedian = dynamic_median_angles;

disp('Expt data reorganization complete')



%% (!) USER INPUT: load the compiled dynamic and static variables for next
% expt

% RUN FOLLOWING COMMANDS to reorganize data for plotting


% Find change in spheroid area
dday2areas = (dynamic_day2areas - dynamic_day0areas); 
ds_day2areas = (static_day2areas - static_day0areas);


% Organize persistence speed data for each spheroid within expt ----------------------------------
% --- static

static_max_speed = max(static_speeds{1});
static_mean_speed = mean(static_speeds{1});
static_median_speed = median(static_speeds{1});

for i = 2:size(static_speeds, 2)
    static_max_speed = [static_max_speed, max(static_speeds{i})];
    static_mean_speed = [static_mean_speed, mean(static_speeds{i})];
    static_median_speed = [static_median_speed, median(static_speeds{i})];
end

% ---dynamic
dynamic_max_speed = max(dynamic_speeds{1});
dynamic_mean_speed = mean(dynamic_speeds{1});
dynamic_median_speed = median(dynamic_speeds{1});

for i = 2:size(dynamic_speeds, 2)
    dynamic_max_speed = [dynamic_max_speed, max(dynamic_speeds{i})];
    dynamic_mean_speed = [dynamic_mean_speed, mean(dynamic_speeds{i})];
    dynamic_median_speed = [dynamic_median_speed, median(dynamic_speeds{i})];
end



% Organize distance ----------------------------------
% % --- static
% static_max_distances = cell2mat(static_max_distances);
% static_mean_distances = cell2mat(static_mean_distances);
% static_median_distances = cell2mat(static_median_distances);
% 
% % ---dynamic
% dynamic_max_distances = cell2mat(dynamic_max_distances);
% dynamic_mean_distances = cell2mat(dynamic_mean_distances);
% dynamic_median_distances = cell2mat(dynamic_median_distances);

% Organize angles data ----------------------------------
% --- static
static_max_angles = max(static_angles{1});
static_mean_angles = mean(static_angles{1});
static_median_angles = median(static_angles{1});

for i = 2:size(static_angles, 2)
    static_max_angles = [static_max_angles, max(static_angles{i})];
    static_mean_angles = [static_mean_angles, mean(static_angles{i})];
    static_median_angles = [static_median_angles, median(static_angles{i})];
end


% ---dynamic
dynamic_max_angles = max(dynamic_angles{1});
dynamic_mean_angles = mean(dynamic_angles{1});
dynamic_median_angles = median(dynamic_angles{1});

for i = 2:size(dynamic_angles, 2)
    dynamic_max_angles = [dynamic_max_angles, max(dynamic_angles{i})];
    dynamic_mean_angles = [dynamic_mean_angles, mean(dynamic_angles{i})];
    dynamic_median_angles = [dynamic_median_angles, median(dynamic_angles{i})];
end



%--- Add values for next expts of the cell type

Sareas = [Sareas, ds_day2areas];
Dareas = [Dareas, dday2areas];

S_speedmax = [S_speedmax, static_max_speed];
S_speedmedian = [S_speedmedian, static_median_speed];
S_speedmean = [S_speedmean, static_mean_speed];

D_speedmax = [D_speedmax, dynamic_max_speed];
D_speedmedian = [D_speedmedian, dynamic_median_speed];
D_speedmean = [D_speedmean, dynamic_mean_speed];

SIxb = [SIxb, Ixb_static]; SIxc = [SIxc, Ixc_static];
SIyb = [SIyb, Iyb_static]; SIyc = [SIyc, Iyc_static];
SIrb = [SIrb, Irb_static]; SIrc = [SIrc, Irc_static];

DIxb = [DIxb, Ixb_dynamic]; DIxc = [DIxc, Ixc_dynamic];
DIyb = [DIyb, Iyb_dynamic]; DIyc = [DIyc, Iyc_dynamic];
DIrb = [DIrb, Irb_dynamic]; DIrc = [DIrc, Irc_dynamic];


S_distmax = [S_distmax, static_max_distances];
S_distmean = [S_distmean, static_mean_distances];
S_distmedian = [S_distmedian, static_median_distances];

D_distmax = [D_distmax, dynamic_max_distances];
D_distmean = [D_distmean, dynamic_mean_distances];
D_distmedian = [D_distmedian, dynamic_median_distances];

S_anglesmax = [S_anglesmax, static_max_angles];
S_anglesmean = [S_anglesmean, static_mean_angles];
S_anglesmedian = [S_anglesmedian, static_median_angles];

D_anglesmax = [D_anglesmax, dynamic_max_angles];
D_anglesmean = [D_anglesmean, dynamic_mean_angles];
D_anglesmedian = [D_anglesmedian, dynamic_median_angles];

disp('Expt data reorganization complete')


%% Clear old variables

clear dday2areas ds_day2areas i
clear static_day0areas static_day2areas dynamic_day0areas dynamic_day2areas
clear static_max_speed static_median_speed static_mean_speed static_speeds
clear dynamic_max_speed dynamic_median_speed dynamic_mean_speed dynamic_speeds
clear Ixb_static Iyb_static Irb_static Ixc_static Iyc_static Irc_static
clear Ixb_dynamic Iyb_dynamic Irb_dynamic Ixc_dynamic Iyc_dynamic Irc_dynamic
clear static_max_distances static_mean_distances static_median_distances
clear dynamic_max_distances dynamic_mean_distances dynamic_median_distances
clear static_angles static_max_angles static_mean_angles static_median_angles
clear dynamic_angles dynamic_max_angles dynamic_mean_angles dynamic_median_angles


%% Convert un-necesarry cells to arrays


S_distmax = cell2mat(S_distmax);
S_distmean = cell2mat(S_distmean);
S_distmedian = cell2mat(S_distmedian);

D_distmax = cell2mat(D_distmax);
D_distmean = cell2mat(D_distmean);
D_distmedian = cell2mat(D_distmedian);




%%
% (!) USER INPUT: save the workspace for this cell type


