%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; October 2022
% -------------------PART 4----------------------
%---------- USE ON CONSOLIDATED QUANTIFIED DATA ------------
% Perform PCA on consilidated data

clear ; clc; close all
%close all

%% Prompt the user to input a value for a variable ------

expt_no = input('What is the experiment number?  ');
condition = input('What is the experiment condition?  ' , 's');
num_days = input('What are the number of days of the experiment?  ');
pixel_size = input('What is the um/pixel ratio of your images?  ');

% Display the specified variable value
disp(['Experiment #:  ' num2str(expt_no)]);
disp(['Condition: ' num2str(condition)]);
disp(['Number of days:  ' num2str(num_days)]);
disp(['Pixel size #: ' num2str(pixel_size)]);


% % State your experiment details ------ %Use if preferred over prompt
% 
% % State the experiment number and condition --------------------
% expt_no = '9';
% condition = 'static';
% 
% % Experiment duration
% % - example: Day 0 to Day 4
% num_days = 4;
% 
% %Pixel size of your microscope images
% pixel_size = 0.75488; %um/pixel


%% Prompt the user to load variables saved from an experiment ----------

% - - This script is designed to work on the variables that 
% - - you saved using "ConsolidateData.m"

% - prompt the user to select a MATLAB file
disp('Select a MATLAB .mat file to load variables.')
[filename0, filePath] = uigetfile('*.mat', 'Select a MATLAB file');

% - Check if the user clicked 'Cancel'
if isequal(filename0, 0)
    disp('User canceled file selection.');
    return; % Terminate the script if the user cancels
end

% - Construct the full file path
full_filepath = fullfile(filePath, filename0);

% - Load the MATLAB file
try
    %loadedData = load(fullFilePath);
    load(full_filepath);
    disp(['MATLAB file loaded from: ' full_filepath]);

catch
    disp('Error loading the MATLAB file.');
end


% If needed, revert speeds back to distances ------------------
% speedum_array = (outerdistance_lengths_um) / (num_days*24*60); %um/min

static_outerdist_um = cell(1, length(static_speeds));

for i = 1:length(static_outerdist_um)
    static_outerdist_um{i} = static_speeds{i} .* (num_days*24*60); %um
end

% ------------------------------------------



%% Run PCA function

%If this function breaks, check that you are using the variables saved in
%ConsolidateData.m"
[principal_angles, mean_transformed_dist, principal_Irb, principal_Ixb, principal_Iyb, ...
    transformed_angles, transformed_dist_um] = PerformPCA(static_angles, static_outerdist_um, pixel_size);

mt_dist_difference = mean_transformed_dist(:,1)-mean_transformed_dist(:,2);

% %---------------------%
% disp('Paused, check on figures and type next to proceed to saving figures and variables.')
% input('next')
% %---------------------%


%% Save data

% Create a new folder to store the figures and variables
new_foldername = ['PCA figs+vars expt', num2str(expt_no), ' ', condition];
%new_foldername = ['PCA figs+vars expt',expt_no, ' ', condition];
new_folderpath = fullfile(pwd, new_foldername);
mkdir(new_folderpath);

 % (1) Save as matlab figures ...................
fig_handles = flip(findall(0,'Type','figure'),1);

% Save each figure with a unique file name in the specified folder
for i = 1:numel(fig_handles)
    
    % Specify the file name for the saved figure
    filename0 = ['PCA expt', num2str(expt_no), ' Fig' num2str(i) , ' ', condition];

    % Full file path including the folder, file name, and extension
    full_filepath = fullfile(new_folderpath, [filename0, '.fig']);

    % Save the figure as a .fig file (MATLAB figure file)
    saveas(i, full_filepath, 'fig');

    disp(['Figure ' num2str(i) ' saved to: ' full_filepath]);
end


%Example of how to save the figures as png files 
% (To do: uncomment, click on the figure you want to save, then replace with preferred name and run the line)

%saveas(gcf,'2_day2_PCA_14S_nopostcontrol.png')


% (2) Save figures into a pdf file .................
cd(new_folderpath)

% Method using the exportgraphics function (works with MATLAB R2022a+)
pdf_name = ['PCA figures expt',  num2str(expt_no), ' ', condition, '.pdf'];
disp(['Now writing: ',pdf_name]);
fig_handles = flip(findall(0,'Type','figure'),1);

exportgraphics(fig_handles(1),pdf_name)
for i = 2:numel(fig_handles)        
    exportgraphics(fig_handles(i),pdf_name, 'append', true)
end
    
    
% Save the variables

disp('Saving relevant workspace variables to file explorer')
save(['PCA variables expt',  num2str(expt_no), ' ', condition, ' compiled'], ...
    'principal_angles', 'mean_transformed_dist', 'mt_dist_difference', 'principal_Irb', 'principal_Ixb', ...
    'principal_Iyb', 'transformed_angles', 'transformed_dist_um')
disp(' ')
disp('End of function')

% ------------------------------- END OF PART 4 ------------
