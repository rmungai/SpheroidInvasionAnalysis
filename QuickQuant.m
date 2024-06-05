%% Image quantification MATLAB script for 3D spheroid migration on pixels
%% NOT FOR PUBLISHING
%
% Author: Rozanne W. Mungai 
% - Billiar Lab, Worcester Polytechnic Institute
% Created May 2024
%
%               ---------------------
%
% Extra script for me to quickly run the Quant_imageset.m script, esp for
% testing effect of binarization threshold values on PIXEL quantification
%
% Requirements: Binarized images 
% 
% Run this then start the Quant_imageset.m script from the second section 

%%
clear; close all; clc

% State your experiment details
E = '12'; %expt number
bthres = '0.28'; %binarizing threshold
%expt_no = '12 0.04';
expt_no = [num2str(E), ' ', num2str(bthres)]; %expt no and bthres
condition = 'dynamic';

% Experiment duration
% - example: Day 0 to Day 2
num_days = 2;

%Pixel size of your microscope images
pixel_size = 0.75488; %um/pixel

%Initialize image detailes for loading
selected_folder = ['C:\Users\rozie\OneDrive\Documents\MATLAB\Expt12-19 CopyForGitHub - PixelSquaresQuickDistances\Binarized ', num2str(bthres), 'T_E', num2str(E), '_dynamic']
%selected_folder = 'C:\Users\rozie\OneDrive\Documents\MATLAB\Expt12-19 CopyForGitHub - PixelSquaresQuickDistances\Binarized 0.04T_E12_dynamic'
addpath(selected_folder)

files = {['6_maskedBW1 ', num2str(bthres), 'T_E', num2str(E), '_', num2str(condition), '.tif'],...
    ['6_maskedBW2 ', num2str(bthres), 'T_E', num2str(E), '_', num2str(condition), '.tif']};
% files = {'6_maskedBW1 0.04T_E12_dynamic.tif', '6_maskedBW2 0.04T_E12_dynamic.tif'}
% filename0 = '6_maskedBW1 0.28T_E12_dynamic.tif';
% binarized_day0 = '6_maskedBW1 0.28T_E12_dynamic.tif';
% binarized_day2 = '6_maskedBW2 0.28T_E12_dynamic.tif';

%files = {'6_maskedBW1_E12_static.tif', '6_maskedBW2_E18_static.tif'};
filename0 = files{1};
binarized_day0 = files{1};
binarized_day2 = files{2};



%% Run this part after quantification

%Display values in mm units (area = mm2, dist = mm, moment = mm4)

num_FilteredBlobs = numel(outer_areas2(:, 1))

outer_areas_mm = sum(outer_areas2) * (pixel_size/1e3)^2
%area_change_mm = (sum(areas2) - sum(areas)) * (pixel_size/1e3)^2
% %^use area change if not filtering nuclei 

mean_dist_mm = mean_dist/1e3
Irb_mm = Irb*(pixel_size/1e3)^4


% Add the new variables to teh existing .mat data file
save(['Vars expt', expt_no, ' ', condition, ' sph6.mat'], 'num_FilteredBlobs',...
    'outer_areas_mm', 'mean_dist_mm', 'Irb_mm', '-append')

rmpath(selected_folder)




