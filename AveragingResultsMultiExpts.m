%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; October 2022
% -------------------PART 4----------------------
%---------- USE ON COMPILED QUANTIFIED DATA ------------
% Average results on consilidated data for multiple experiments for one cell type

%clear ; clc; close all

%%
% (!) USER INPUT: load the compiled dynamic and static variables for first
% expt

% RUN FOLLOWING COMMANDS to reorganize data and calculate averages for experiments

% Normalize the areas (fold change): (Y-X)/X
nd_day2areas = (dynamic_day2areas - dynamic_day0areas) ./dynamic_day0areas; 
ns_day2areas = (static_day2areas - static_day0areas) ./static_day0areas;


% Organize persistence speed data ----------------------------------
% --- static

static_max_speed = max(static_speeds{1});
static_mean_speed = mean(static_speeds{1});
static_median_speed = median(static_speeds{1});

for i = 2:size(static_speeds, 2)
    static_max_speed = [static_max_speed, max(static_speeds{i})];
    static_mean_speed = [static_mean_speed, mean(static_speeds{i})];
    static_median_speed = [static_median_speed, median(static_speeds{i})];
end

% static_max_speed = [max(static_speeds{1}), max(static_speeds{2}),max(static_speeds{3})];
% static_mean_speed = [mean(static_speeds{1}), mean(static_speeds{2}),mean(static_speeds{3})];
% static_median_speed = [median(static_speeds{1}), median(static_speeds{2}),median(static_speeds{3})];

% - Old method
% static_speedsavg = [mean(static_speeds{1}), mean(static_speeds{2}), mean(static_speeds{3}) ];
% 
% static_max_speed = max(static_speedsavg);
% static_median_speed = median(static_speedsavg);
% static_mean_speed = mean(static_speedsavg);


% ---dynamic
dynamic_max_speed = max(dynamic_speeds{1});
dynamic_mean_speed = mean(dynamic_speeds{1});
dynamic_median_speed = median(dynamic_speeds{1});

for i = 2:size(dynamic_speeds, 2)
    dynamic_max_speed = [dynamic_max_speed, max(dynamic_speeds{i})];
    dynamic_mean_speed = [dynamic_mean_speed, mean(dynamic_speeds{i})];
    dynamic_median_speed = [dynamic_median_speed, median(dynamic_speeds{i})];
end


% dynamic_max_speed = [max(dynamic_speeds{1}), max(dynamic_speeds{2}),max(dynamic_speeds{3})];
% dynamic_mean_speed = [mean(dynamic_speeds{1}), mean(dynamic_speeds{2}),mean(dynamic_speeds{3})];
% dynamic_median_speed = [median(dynamic_speeds{1}), median(dynamic_speeds{2}),median(dynamic_speeds{3})];

%-Old method
% dynamic_speedsavg = [mean(dynamic_speeds{1}), mean(dynamic_speeds{2}), mean(dynamic_speeds{3}),...
%     mean(dynamic_speeds{4}), mean(dynamic_speeds{5}) ];
% 
% dynamic_max_speed = max(dynamic_speedsavg);
% dynamic_median_speed = median(dynamic_speedsavg);
% dynamic_mean_speed = mean(dynamic_speedsavg);

% Organize moment of inertia data -------------------

static_Ix_mean = mean(Ix_static);
static_Iy_mean = mean(Iy_static);
static_Ir_mean = mean(Ir_static);

dynamic_Ix_mean = mean(Ix_dynamic);
dynamic_Iy_mean = mean(Iy_dynamic);
dynamic_Ir_mean = mean(Ir_dynamic);


% Organize distance ----------------------------------
% --- static
static_max_distances = mean(cell2mat(static_max_distances));
static_mean_distances = mean(cell2mat(static_mean_distances));
static_median_distances = mean(cell2mat(static_median_distances));

% ---dynamic
dynamic_max_distances = mean(cell2mat(dynamic_max_distances));
dynamic_mean_distances = mean(cell2mat(dynamic_mean_distances));
dynamic_median_distances = mean(cell2mat(dynamic_median_distances));


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



% Calculate averages for each expt --------------------------------


% %----- VIC data: Experiments 12, 13, 14
% VIC_Sareas = zeros(1,3); VIC_Dareas = zeros(1,3);
% 
% VIC_S_speedmax = zeros(1,3); VIC_S_speedmean = zeros(1,3); VIC_S_speedmedian = zeros(1,3);
% VIC_D_speedmax = zeros(1,3); VIC_D_speedmean = zeros(1,3); VIC_D_speedmedian = zeros(1,3);

% Sareas = zeros(1,3); Dareas = zeros(1,3);
% 
% S_speedmax = zeros(1,3); S_speedmean = zeros(1,3); S_speedmedian = zeros(1,3);
% D_speedmax = zeros(1,3); D_speedmean = zeros(1,3); D_speedmedian = zeros(1,3);



%---- Initialize values for the first expt in cell group

Sareas = mean(ns_day2areas);
Dareas = mean(nd_day2areas);

S_speedmax = mean(static_max_speed);
S_speedmedian = mean(static_median_speed);
S_speedmean = mean(static_mean_speed);

D_speedmax = mean(dynamic_max_speed);
D_speedmedian = mean(dynamic_median_speed);
D_speedmean = mean(dynamic_mean_speed);

SIx_mean = static_Ix_mean;
SIy_mean = static_Iy_mean;
SIr_mean = static_Ir_mean;

DIx_mean = dynamic_Ix_mean;
DIy_mean = dynamic_Iy_mean;
DIr_mean = dynamic_Ir_mean;


S_distmax = static_max_distances;
S_distmean = static_mean_distances;
S_distmedian = static_median_distances;

D_distmax = dynamic_max_distances;
D_distmean = dynamic_mean_distances;
D_distmedian = dynamic_median_distances;



% Sareas(1) = mean(ns_day2areas);
% Dareas(1) = mean(nd_day2areas);
% 
% S_speedmax(1) = mean(static_max_speed);
% S_speedmedian(1) = mean(static_median_speed);
% S_speedmean(1) = mean(static_mean_speed);
% 
% D_speedmax(1) = mean(dynamic_max_speed);
% D_speedmedian(1) = mean(dynamic_median_speed);
% D_speedmean(1) = mean(dynamic_mean_speed);

%% 
% (!) USER INPUT: load the compiled dynamic and static variables for next
% expt

% RUN FOLLOWING COMMANDS to reorganize data for plotting

% Normalize the areas (fold change): (Y-X)/X
nd_day2areas = (dynamic_day2areas - dynamic_day0areas) ./dynamic_day0areas; 
ns_day2areas = (static_day2areas - static_day0areas) ./static_day0areas;


% Organize persistence speed data ----------------------------------
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

% Organize moment of inertia data

static_Ix_mean = mean(Ix_static);
static_Iy_mean = mean(Iy_static);
static_Ir_mean = mean(Ir_static);

dynamic_Ix_mean = mean(Ix_dynamic);
dynamic_Iy_mean = mean(Iy_dynamic);
dynamic_Ir_mean = mean(Ir_dynamic);


% Organize distance ----------------------------------
% --- static
static_max_distances = mean(cell2mat(static_max_distances));
static_mean_distances = mean(cell2mat(static_mean_distances));
static_median_distances = mean(cell2mat(static_median_distances));

% ---dynamic
dynamic_max_distances = mean(cell2mat(dynamic_max_distances));
dynamic_mean_distances = mean(cell2mat(dynamic_mean_distances));
dynamic_median_distances = mean(cell2mat(dynamic_median_distances));



%--- Add values for next expts in the cell group

Sareas = [Sareas, mean(ns_day2areas)];
Dareas = [Dareas, mean(nd_day2areas)];

S_speedmax = [S_speedmax, mean(static_max_speed)];
S_speedmedian = [S_speedmedian, mean(static_median_speed)];
S_speedmean = [S_speedmean, mean(static_mean_speed)];

D_speedmax = [D_speedmax, mean(dynamic_max_speed)];
D_speedmedian = [D_speedmedian, mean(dynamic_median_speed)];
D_speedmean = [D_speedmean, mean(dynamic_mean_speed)];

SIx_mean = [SIx_mean, static_Ix_mean];
SIy_mean = [SIy_mean, static_Iy_mean];
SIr_mean = [SIr_mean, static_Ir_mean];

DIx_mean = [DIx_mean, dynamic_Ix_mean];
DIy_mean = [DIy_mean, dynamic_Iy_mean];
DIr_mean = [DIr_mean, dynamic_Ir_mean];

S_distmax = [S_distmax, static_max_distances];
S_distmean = [S_distmean, static_mean_distances];
S_distmedian = [S_distmedian, static_median_distances];

D_distmax = [D_distmax, dynamic_max_distances];
D_distmean = [D_distmean, dynamic_mean_distances];
D_distmedian = [D_distmedian, dynamic_median_distances];


%% Clear old variables

clear nd_day2areas ns_day2areas i
clear static_day0areas static_day2areas dynamic_day0areas dynamic_day2areas
clear static_max_speed static_median_speed static_mean_speed static_speeds
clear dynamic_max_speed dynamic_median_speed dynamic_mean_speed dynamic_speeds
clear Ix_static Iy_static Ir_static static_Ix_mean static_Iy_mean static_Ir_mean
clear Ix_dynamic Iy_dynamic Ir_dynamic dynamic_Ix_mean dynamic_Iy_mean dynamic_Ir_mean
clear static_max_distances static_mean_distances static_median_distances
clear dynamic_max_distances dynamic_mean_distances dynamic_median_distances
clear static_angles static_max_angles static_mean_angles static_median_angles
clear dynamic_angles dynamic_max_angles dynamic_mean_angles dynamic_median_angles


%%
% (!) USER INPUT: save the workspace for this cell type


