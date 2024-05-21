%% Image quantification MATLAB script for 3D spheroid migration
%% NOT FOR PUBLISHING
%
% Author: Rozanne W. Mungai 
% - Billiar Lab, Worcester Polytechnic Institute
% Created May 2024
%
%               ---------------------
%
% Extra script for me to quickly run the Quant_imageset.m script, esp for
% testing effect of binarization threshold values
%
% Requirements: Binarized images 
% 
% Run this then start the Quant_imageset.m script from the second section 

%%
clear; close all; clc

% State your experiment details
expt_no = '12 0.28T';
condition = 'dynamic';

% Experiment duration
% - example: Day 0 to Day 2
num_days = 2;

%Pixel size of your microscope images
pixel_size = 0.75488; %um/pixel

%Initialize image detailes for loading
selected_folder = 'C:\Users\rozie\OneDrive\Documents\MATLAB\Expt12-19 CopyForGitHub - PixelSquaresQuickDistances\Binarized 0.28T_E12_dynamic';
addpath(selected_folder)

files = {'6_maskedBW1 0.28T_E12_dynamic.tif', '6_maskedBW2 0.28T_E12_dynamic.tif'};
filename0 = '6_maskedBW1 0.28T_E12_dynamic.tif';
binarized_day0 = '6_maskedBW1 0.28T_E12_dynamic.tif';
binarized_day2 = '6_maskedBW2 0.28T_E12_dynamic.tif';


%% Run this part after quantification

%Display values in mm units (area = mm2, dist = mm, moment = mm4)
area_change_mm = (sum(areas2) - sum(areas)) * (pixel_size/1e3)^2
mean_dist_mm = mean_dist/1e3
Irb_mm = Irb*(pixel_size/1e3)^4