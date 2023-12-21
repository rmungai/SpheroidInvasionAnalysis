%% Image quantification MATLAB script for 3D spheroid migration

clear ; clc; close all

%% Step 1: Prompt the user to load the saved variables from all the spheorids in one expt

% Prompt the user to select multiple MATLAB files
disp('Select all the saved spheroid variable .mat files to compile for one expt condition.')
[files, path] = uigetfile('*.mat', 'Select all saved spheroid variable to compile for one expt', 'MultiSelect', 'on');

% Check if the user clicked 'Cancel'
if isequal(files, 0)
    disp('User canceled file selection.');
else
    disp(['Successfully selected ', num2str(length(files)), ' files']);
end

% If only one file is selected, convert it to a cell array for consistency
if ~iscell(files)
    files = {files};
end



%% Loop through each selected file and load it

for i = 1:length(files)
    

    % Construct the full file path
    full_filepath = fullfile(path, files{i});

    % Add the folder to the MATLAB path
    addpath(path);

    % Load the MATLAB file
    try
        load(files{i});
        %loadedData = load(full_filepath);
        

        % Re-assign variables to build arrays and cells --------------

        max_dist = max_distance;
        mean_dist = mean_distance;
        median_dist = median_distance

        disp(['MATLAB file loaded from: ' full_filepath]);
        disp('Values successfully reassigned.');

        % ------------------------------------------------------------




        %% Step 2: Save the workspace into one large cell and as a .mat file
        
        % Save workspace ---------------------------------------------------
        % Prompt the user to select a file to save the workspace
        [filename0, path] = uiputfile('*.mat', 'Save Workspace As');
        
        % Check if the user clicked 'Cancel'
        if isequal(filename0, 0)
            disp('User canceled file selection.');
            return; % Terminate the script if the user cancels
        end
        
        % Construct the full file path
        full_filepath = fullfile(path, filename0);
        
        % Save the workspace to the selected file
        try
            save(full_filepath);
            disp(['Workspace saved to: ' full_filepath]);
        catch
            disp(['Error saving workspace to: ' full_filepath]);
        end



 catch
        disp(['Error loading and reassigning MATLAB file: ' full_filepath]);
                
    end
end

