%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; October 2022
% -------------------PART 3----------------------
%---------- USE ON QUANTIFIED DATA ------------
% Consolidate the data of all the spheroids in an experiment together

clear ; clc; close all


%% Prompt the user to input a value for a variable ------
expt_no = input('What is the experiment number?  ', 's');
condition = input('What is the experiment condition?  ' , 's');

% Display the specified variable value
disp(['Experiment #: ' num2str(expt_no)]);
disp(['Condition: ' num2str(condition)]);


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


%%
% Initialize variables
angles = cell(1,length(files));
speedsum = cell(1,length(files));
day0_area = zeros(1,length(files));
dayF_area = zeros(1,length(files));

Irc = zeros(1,length(files)); Irc = zeros(1,length(files));
Ixc = zeros(1,length(files)); Ixc = zeros(1,length(files));
Iyc = zeros(1,length(files)); Iyc = zeros(1,length(files));

max_distances = zeros(1,length(files));
mean_distances = zeros(1,length(files));
median_distances = zeros(1,length(files));


% Loop through each selected file and load it
for i = 1:length(files)
    

    % Construct the full file path
    full_filepath = fullfile(path, files{i});

    % Load the MATLAB file
    try
        load(files{i});
        %loadedData = load(full_filepath);
        

        % Re-assign variables to build arrays and cells --------------

        % - Each angle and speed value corresponds to one pixel in a
        % spheroid. Therefore, those values are listed in one array per spheroid
        angles{i} = angles_array;       
        speedsum{i} = speedum_array;
                
        % - Each area, distance and moment of inertia value corresponds to
        % one spheroid
        day0_area(i) = sum(areas);
        dayF_area(i) = sum(areas2);

        % Reassign values for area moment of inertia
        % - radial (r) and x-y-directions
        % - calculated from the Day 0 boundary (b) and spheroid center (c)
         
        I_rb(i) = Irb; I_rc(i) = Irc;
        I_xb(i) = Ixb; I_xc(i) = Ixc;
        I_yb(i) = Iyb; I_yc(i) = Iyc;
        
        % % Reassign values for distance from the boundary
        max_distances(i) = max_distance;
        mean_distances(i) = mean_distance;
        median_distances(i) = median_distance;
        % max_distances(i) = max_dist;
        % mean_distances(i) = mean_dist;
        % median_distances(i) = median_dist;

        disp(['MATLAB file loaded from: ' full_filepath]);
        disp('Values successfully reassigned.');

        % ------------------------------------------------------------


        % Clear un-needed variables from the workspace
        clear final_pixels Irb Irc Ixb Ixc Iyb Iyc max_dist mean_dist median_dist
        clear areas areas2 angles_array speedum_array files i path
    
    
    
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
        
        % Save workspace vars in a cell ----------------------------------------
        
        %cd(filename0)
        
        myvars = who;
        VariablesCell = cell(length(myvars),2);
        VariablesCell(:,1) = myvars;
        for i = 1:length(VariablesCell)
            VariablesCell(i,2) = {eval(sprintf('%1$s', myvars{i}))};
        end
        
        save(['Vars compiled expt ' expt_no, ' ', condition], VariablesCell)

        % ---------------------------------------------------------------


    catch
        disp(['Error loading and reassigning MATLAB file: ' full_filepath]);
                
    end
end

