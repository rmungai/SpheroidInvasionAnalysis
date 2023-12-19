%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; October 2022
% -------------------PART 5----------------------
%---------- USE ON COMPILED QUANTIFIED DATA ------------
% Perform PCA on consilidated data

clear ; clc; close all
%close all

%% (!) USER INPUT: Specify experiment details

% State the experiment number and condition --------------------
expt_no = '9';
%condition = 'static PC9 uncut';
condition = 'static';

% State length of experiment (days) and image pixel size -------
num_days = 4;

% - Images captured at 10X on Keyence microscope
%  - 0.75488 um/pixel
pixel_size = 0.75488; %um/pixel


% (!) Load the compiled dynamic and static variables for each cell type
%load('Vars complied expt 12 static.mat')
load('Vars complied expt 9 static.mat')


%% Run PCA function
[principle_angles, principle_speeds, principle_Irb, principle_Ixb, principle_Iyb, transformed_angles, transformed_speeds] = PerformPCA(static_angles, ...
    static_speeds, num_days, pixel_size);

prin_speed_difference = principle_speeds(:,1)-principle_speeds(:,2);

%---------------------%
disp('Paused, check on figures and type next to save the relevant variables')
input('next')
%---------------------%

%% Save data


%Save the figures  

pdf_name = ['PCA figures expt',  expt_no, ' ', condition, ' .pdf'];
disp(['Now writing: ',pdf_name]);
figHandles = flip(findall(0,'Type','figure'),1);

exportgraphics(figHandles(1),pdf_name)
for i = 2:numel(figHandles)        
    exportgraphics(figHandles(i),pdf_name, 'append', true)
end
    
    
%Save the variables

disp('Saving relevant workspace variables to file explorer')
save(['PCA varaibles expt',  expt_no, ' ', condition, ' compiled'], ...
    'principle_angles', 'principle_speeds', 'prin_speed_difference', 'principle_Irb', 'principle_Ixb', 'principle_Iyb', ...
    'transformed_angles', 'transformed_speeds')
disp(' ')
disp(' ')


