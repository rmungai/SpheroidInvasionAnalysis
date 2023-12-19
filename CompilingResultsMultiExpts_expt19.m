%% Image quantification MATLAB script for 3D spheroid migrationRPE_s
% Rozanne Mungai Billiar Lab; October 2022
% -------------------PART 4----------------------
%---------- USE ON COMPILED QUANTIFIED DATA ------------
% Compile results on consilidated data for multiple experiments for one cell type

%clear ; clc; close all

%%
% (!) USER INPUT: load the compiled RPEs and PC9s variables for first
% expt

% RUN FOLLOWING COMMANDS to reorganize data and compile data for experiments

% Find change in spheroid area
dr_day2areas = RPEs_day2areas - RPEs_day0areas; 
dp_day2areas = PC9s_day2areas - PC9s_day0areas;

% Old: Normalize the areas (fold change): (Y-X)/X
%nd_day2areas = (RPEs_day2areas - RPEs_day0areas) ./RPEs_day0areas; 



% Organize persistence speed data for each spheroid within experiment ----------------------------------
% --- PC9s

PC9s_max_speed = max(PC9s_speeds{1});
PC9s_mean_speed = mean(PC9s_speeds{1});
PC9s_median_speed = median(PC9s_speeds{1});

for i = 2:size(PC9s_speeds, 2)
    PC9s_max_speed = [PC9s_max_speed, max(PC9s_speeds{i})];
    PC9s_mean_speed = [PC9s_mean_speed, mean(PC9s_speeds{i})];
    PC9s_median_speed = [PC9s_median_speed, median(PC9s_speeds{i})];
end

% ---RPEs
RPEs_max_speed = max(RPEs_speeds{1});
RPEs_mean_speed = mean(RPEs_speeds{1});
RPEs_median_speed = median(RPEs_speeds{1});

for i = 2:size(RPEs_speeds, 2)
    RPEs_max_speed = [RPEs_max_speed, max(RPEs_speeds{i})];
    RPEs_mean_speed = [RPEs_mean_speed, mean(RPEs_speeds{i})];
    RPEs_median_speed = [RPEs_median_speed, median(RPEs_speeds{i})];
end



% Organize distances for each spheroid within each expt ----------------------------------
% % --- PC9s
% PC9s_max_distances = cell2mat(PC9s_max_distances);
% PC9s_mean_distances = cell2mat(PC9s_mean_distances);
% PC9s_median_distances = cell2mat(PC9s_median_distances);
% 
% % ---RPEs
% RPEs_max_distances = cell2mat(RPEs_max_distances);
% RPEs_mean_distances = cell2mat(RPEs_mean_distances);
% RPEs_median_distances = cell2mat(RPEs_median_distances);


% Organize angles data ----------------------------------
% --- PC9s
PC9s_max_angles = max(PC9s_angles{1});
PC9s_mean_angles = mean(PC9s_angles{1});
PC9s_median_angles = median(PC9s_angles{1});

for i = 2:size(PC9s_angles, 2)
    PC9s_max_angles = [PC9s_max_angles, max(PC9s_angles{i})];
    PC9s_mean_angles = [PC9s_mean_angles, mean(PC9s_angles{i})];
    PC9s_median_angles = [PC9s_median_angles, median(PC9s_angles{i})];
end


% ---RPEs
RPEs_max_angles = max(RPEs_angles{1});
RPEs_mean_angles = mean(RPEs_angles{1});
RPEs_median_angles = median(RPEs_angles{1});

for i = 2:size(RPEs_angles, 2)
    RPEs_max_angles = [RPEs_max_angles, max(RPEs_angles{i})];
    RPEs_mean_angles = [RPEs_mean_angles, mean(RPEs_angles{i})];
    RPEs_median_angles = [RPEs_median_angles, median(RPEs_angles{i})];
end



%---- Initialize values for the first expt in cell group

Sp_areas = dp_day2areas;
Sr_areas = dr_day2areas;

Sp_speedmax = PC9s_max_speed;
Sp_speedmedian = PC9s_median_speed;
Sp_speedmean = PC9s_mean_speed;

Sr_speedmax = RPEs_max_speed;
Sr_speedmedian = RPEs_median_speed;
Sr_speedmean = RPEs_mean_speed;

Sp_Ixb = Ixb_PC9s; Sp_Ixc = Ixc_PC9s;
Sp_Iyb = Iyb_PC9s; Sp_Iyc = Iyc_PC9s;
Sp_Irb = Irb_PC9s; Sp_Irc = Irc_PC9s;

Sr_Ixb = Ixb_RPEs; Sr_Ixc = Ixc_RPEs;
Sr_Iyb = Iyb_RPEs; Sr_Iyc = Iyc_RPEs;
Sr_Irb = Irb_RPEs; Sr_Irc = Irc_RPEs;


Sp_distmax = PC9s_max_distances;
Sp_distmean = PC9s_mean_distances;
Sp_distmedian = PC9s_median_distances;

Sr_distmax = RPEs_max_distances;
Sr_distmean = RPEs_mean_distances;
Sr_distmedian = RPEs_median_distances;

Sp_anglesmax = PC9s_max_angles;
Sp_anglesmean = PC9s_mean_angles;
Sp_anglesmedian = PC9s_median_angles;

Sr_anglesmax = RPEs_max_angles;
Sr_anglesmean = RPEs_mean_angles;
Sr_anglesmedian = RPEs_median_angles;

disp('Expt data reorganization complete')



%% Clear old variables

clear dr_day2areas dp_day2areas i
clear PC9s_day0areas PC9s_day2areas RPEs_day0areas RPEs_day2areas
clear PC9s_max_speed PC9s_median_speed PC9s_mean_speed PC9s_speeds
clear RPEs_max_speed RPEs_median_speed RPEs_mean_speed RPEs_speeds
clear Ixb_PC9s Iyb_PC9s Irb_PC9s Ixc_PC9s Iyc_PC9s Irc_PC9s
clear Ixb_RPEs Iyb_RPEs Irb_RPEs Ixc_RPEs Iyc_RPEs Irc_RPEs
clear PC9s_max_distances PC9s_mean_distances PC9s_median_distances
clear RPEs_max_distances RPEs_mean_distances RPEs_median_distances
clear PC9s_angles PC9s_max_angles PC9s_mean_angles PC9s_median_angles
clear RPEs_angles RPEs_max_angles RPEs_mean_angles RPEs_median_angles


%%
% (!) USER INPUT: save the workspace for this cell type


%% Loop through all objects in workspace and save to cell
myvars = who;
Z = cell(length(myvars),2);
Z(:,1) = myvars;
for i = 1:length(Z)
    Z(i,2) = {eval(sprintf('%1$s', myvars{i}))};
end



