%% Image quantification MATLAB script for 3D spheroid migration
%% NOT FOR PUBLISHING
%
% Author: Rozanne W. Mungai 
% - Billiar Lab, Worcester Polytechnic Institute
% Created May 2024
%
%               ---------------------
%
% Extra script for me to quickly make the plots I need using the saved data
% from Quant_imageset.m
%
% Requirements: Saved quantified data (.mat) obtained using PART 2 of the image
% - quantification script set
% 
% Outputs: Polar plots of distances and speeds vs angles



% (!) USER INPUT: State the experiment number and condition - - - - - - - - 
expt_no = '19 RPE-1';
condition = 'static';
spheroid_num = '5';

% State length of experiment (days) and image pixel size

% Comparing day 2 to day 0 for now
num_days = 2;

%Experiment 9-19 images captured at 10X on the Keyence microscope
% - the pixel size is 0.75488 um/pixel
pixel_size = 0.75488; %um/pixel

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 


% Plot the speedum from boundary vs angle values in a polar plot-----------
figure
polarplot(angles_array, speedum_array,'.')
title ('Persistence speed (um/min) vs  migration angle')



% - Set figure size: 
% - https://www.mathworks.com/help/matlab/ref/figure.html#buich1u-1_sep_shared-Position
set(gca,'Fontname','arial', 'FontSize',14, 'OuterPosition', [0 0.2 1 0.75]);


outerdistance_lengths_um  = (speedum_array) * (num_days*24*60); %um/min -> um
outerdistance_lengths_mm  = (outerdistance_lengths_um) / (1e3); %um -> mm

%outerdistance_lengths_um = (outerdistance_lengths)*pixel_size;
%centerdistance_lengths_um = (centerdistance_lengths)*pixel_size;



%Plot the boundary distance (um) vs angle values in a polar plot-----------------
figure 
polarplot(angles_array, outerdistance_lengths_um,'.')
title (["Distances from spheroid boundary (um) vs ","migration angle"])

% - Set figure size: 
% - https://www.mathworks.com/help/matlab/ref/figure.html#buich1u-1_sep_shared-Position
set(gca,'Fontname','arial', 'FontSize',14, 'OuterPosition', [0 0.2 1 0.75]);

%Plot the boundary distance (mm) vs angle values in a polar plot-----------------
figure 
polarplot(angles_array, outerdistance_lengths_mm,'.')
title (["Distances from spheroid boundary (mm) vs ","migration angle"])

% - Set figure size: 
% - https://www.mathworks.com/help/matlab/ref/figure.html#buich1u-1_sep_shared-Position
set(gca,'Fontname','arial', 'FontSize',14, 'OuterPosition', [0 0.2 1 0.75]);




%% Save the figures as matlab figures ...................


% % Prompt the user to input a value for a variable
% expt_no = input('What is the experiment number? (must be a number)');
% condition = input('What is the experiment condition? (Must be either static or dynamic. Input as a string.)');
% num_days = input('What are the number of days of the experiment? (must be a number)');
% pixel_size = input('What is the um/pixel ratio of your images?');
% 
% % Display the specified variable value
% disp(['Experiment #: ' num2str(expt_no)]);
% disp(['Condition: ' num2str(condition)]);
% disp(['Number of days: ' num2str(num_days)]);
% disp(['Pixel size #: ' num2str(pixel_size)]);




%Save the figures using the given variable names
    
figHandles = flip(findall(0,'Type','figure'),1);

% Prompt the user to select a folder for saving the figures
disp('Select a folder for saving the figures')
selectedFolder = uigetdir;

% Check if the user clicked 'Cancel'
if selectedFolder == 0
    disp('User canceled folder selection.');
else
    % Create a new folder with a unique name
    newFolderName = ['Figures expt',expt_no, ' quantified sph#', spheroid_num,' ', condition];
    newFolderPath = fullfile(selectedFolder, newFolderName);
    mkdir(newFolderPath);
    
    % Save each figure with a unique file name in the specified folder
    for i = 1:numel(figHandles)  
        % Specify the file name for the saved figure
        fileName = ['Fig' num2str(i) ' expt',expt_no, ' ', condition, ' quantified sph#', spheroid_num];
        
        % Full file path including the folder, file name, and extension
        fullFilePath = fullfile(newFolderPath, [fileName, '.fig']);
        
        % Save the figure as a .fig file (MATLAB figure file)
        saveas(i, fullFilePath, 'fig');
        
        disp(['Figure ' num2str(i) ' saved to: ' fullFilePath]);
    end
end

%% Save selected figures as png images

saveas(gcf, '3_day2_dist_mm_13S.png');
saveas(gcf, '7_day2_dist_mm_16S.png');
saveas(gcf, '1_day2_dist_mm_17S.png');
saveas(gcf, '7_day2_dist_mm_19PC9.png');
saveas(gcf, '5_day2_dist_mm_19RPE-1.png');
