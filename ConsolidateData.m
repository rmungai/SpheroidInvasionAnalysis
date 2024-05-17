%% Image quantification MATLAB script for 3D spheroid migration
% Author: Rozanne W. Mungai 
% - Billiar Lab, Worcester Polytechnic Institute
% Created October 2022, Published January 2024
%
% ------- PART 3 of image quantification script set ---------
% 
% Requirements: Saved quantified data (.mat) obtained using PART 2 of the image
% - quantification script set
% 
% - For organization purposes use on one experiment condition at a time
%
% Purpose: Consolidate the data of all the spheroids from one experiment condition
% 
% Outputs: Calculated data (.mat file of workspace variables and cell)
% - figures of quantified data (.fig)
% - pdf file demonstrating workflow
% - - each experiment condition a separate file containing all its
% spheroids

clear ; clc; close all


%% Prompt the user to input a value for a variable ------
% expt_no = input('What is the experiment number?  ', 's');
% condition = input('What is the experiment condition?  ' , 's');
% 
% % Display the specified variable value
% disp(['Experiment #: ' num2str(expt_no)]);
% disp(['Condition: ' num2str(condition)]);


%% Step 1: Prompt the user to load the saved variables from all the spheorids 
% in one experiment condition

% Prompt the user to select multiple MATLAB files
disp('Select all the saved spheroid variable .mat files to compile for one expt condition.')
[my_files, my_path] = uigetfile('*.mat', 'Select all saved spheroid variable to compile for one expt', 'MultiSelect', 'on');

    
% Check if the user clicked 'Cancel'
if isequal(my_files, 0)
    disp('User canceled file selection.');
else
    disp(['Successfully selected ', num2str(length(my_files)), ' files']);
    % Add the folder to the MATLAB path
    addpath(my_path);
    % Display the selected folder path
    disp(['Added selected files to path: ', my_path]);
end

% If only one file is selected, convert it to a cell array for consistency
if ~iscell(my_files)
    my_files = {my_files};
end


%% Step 2: Load and consolidate variables

% Initialize variables
angles = cell(1,length(my_files));
speedsum = cell(1,length(my_files));
day0_area = zeros(1,length(my_files));
dayF_area = zeros(1,length(my_files));

I_rb = zeros(1,length(my_files)); I_rc = zeros(1,length(my_files));
I_xb = zeros(1,length(my_files)); I_xc = zeros(1,length(my_files));
I_yb = zeros(1,length(my_files)); I_yc = zeros(1,length(my_files));

max_distances = zeros(1,length(my_files));
mean_distances = zeros(1,length(my_files));
median_distances = zeros(1,length(my_files));

disp('Successfully initialized variables.')

% Loop through each selected file and load it
for j = 1:length(my_files)
    
    % Construct the full file path
    filepathA = fullfile(my_path, my_files{j});

    % Load the MATLAB file   <--be aware that loop will skip if loop variable is also contained in the loaded file      
    load(my_files{j})
    %loadedData = load(full_filepath);
    disp(['  ', my_files{j}, '  loaded from:  ' filepathA]);
     
    
    % Re-assign variables to build arrays and cells --------------

    % - Each angle and speed value corresponds to one pixel in a
    % spheroid. Therefore, those values are listed in one array per spheroid
    angles{j} = angles_array;       
    speedsum{j} = speedum_array;
            
    % - Each area, distance and moment of inertia value corresponds to
    % one spheroid
    day0_area(j) = sum(areas);
    dayF_area(j) = sum(areas2);
    
    % Reassign values for area moment of inertia
    % - radial (r) and x-y-directions
    % - calculated from the Day 0 boundary (b) and spheroid center (c)
     
    I_rb(j) = Irb; I_rc(j) = Irc;
    I_xb(j) = Ixb; I_xc(j) = Ixc;
    I_yb(j) = Iyb; I_yc(j) = Iyc;
    
    % % Reassign values for distance from the boundary
    % max_distances(j) = max_distance;
    % mean_distances(j) = mean_distance;
    % median_distances(j) = median_distance;
    max_distances(j) = max_dist;
    mean_distances(j) = mean_dist;
    median_distances(j) = median_dist;

         
end


disp(['Successfully reassigned values to ', num2str(length(my_files)), ' files']);

%% ------------------------------------------------------------


% Clear un-needed variables from the workspace
clear final_pixels Irb Irc Ixb Ixc Iyb Iyc max_dist mean_dist median_dist
clear areas areas2 angles_array speedum_array my_files j my_path filepathA



%% Step 3: Save the workspace into one large cell and as a .mat file
    
% Save workspace ---------------------------------------------------
% Prompt the user to select a file to save the workspace
disp('Save the consolidated variables with your desired name.');
[filenameB, my_path] = uiputfile('*.mat', 'Save Workspace As');

% Check if the user clicked 'Cancel'
if isequal(filenameB, 0)
    disp('User canceled file selection.');
    return; % Terminate the script if the user cancels
end

% Construct the full file path
filepathB = fullfile(my_path, filenameB);

% Save the workspace to the selected file
try
    save(filepathB);
    disp(['Workspace saved to: ' filepathB]);
catch
    disp(['Error saving workspace to: ' filepathB]);
end

% Save workspace vars in a cell ----------------------------------------

cd

myvars = who;
VariablesCell = cell(length(myvars),2);
VariablesCell(:,1) = myvars;
for j = 1:length(VariablesCell)
    VariablesCell(j,2) = {eval(sprintf('%1$s', myvars{j}))};
end

clear j filepathB my_path

save(['Cell ',filenameB], 'VariablesCell')
% save(['Vars_compiled_expt', expt_no, '_', condition], 'VariablesCell')

% ---------------------------------------------------------------


% ----------------------- END OF PART 3 ----
    
