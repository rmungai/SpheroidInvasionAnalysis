%% Image quantification MATLAB script for 3D spheroid migration
% Author: Rozanne W. Mungai 
% - Billiar Lab, Worcester Polytechnic Institute
% Created April 2022, Published January 2024
%
% ------- PART 2 of image quantification script set ---------
% 
% Requirements: Initial and final BINARIZED tiff (.tif) images of multicellular spheroids
% - To accomodate automatic file saving, keep track of the spheroids by number 
% and note the number in the beginning of the image name followed by an underscore
% such as: [Spheroid #]_[...] Example: "1_day0_maskedBW_E1.tif"
% - For best results, use PART 1 of the script set to obtain binarized and
% - masked images 
% - For ease of loading the images, keep the images (of one experiment and one condition) in one folder 
% - For organization purposes use on one experiment condition at a time
% 
% Purpose: Trace the boundary of the initial spheroid and quantify cell invasion 
% from multicellular spheroids by calculating the following metrics: 
% - area, distance from inital spheorid center and boundary,
% - angles, area moment of inertia from center and boundary
% 
% Calculations are performed for each pixel past the boundary
% 
% Outputs: Calculated data (as .mat file of workspace variables)
% - figures of quantified data (.fig)
% - pdf file demonstrating workflow
% - - each spheroid has a separate file


clear ; clc; close all

%% Prompt the user to input a value for a variable ------
expt_no = input('What is the experiment number?  ', 's');
condition = input('What is the experiment condition?  ' , 's');
num_days = input('What are the number of days of the experiment?  ');
pixel_size = input('What is the um/pixel ratio of your images?  ');

% Display the specified variable value
disp(['Experiment #: ' num2str(expt_no)]);
disp(['Condition: ' num2str(condition)]);
disp(['Number of days: ' num2str(num_days)]);
disp(['Pixel size #: ' num2str(pixel_size)]);

% % State your experiment details ------ %Use if preferred over prompt
% expt_no = '18';
% condition = 'static';
% 
% % Experiment duration
% % - example: Day 0 to Day 2
% num_days = 2;
% 
% %Pixel size of your microscope images
% pixel_size = 0.75488; %um/pixel


%% Set up folder to obtain images

main_folder = pwd;

% Prompt the user to select a folder
disp('Select a folder to import images.')
selected_folder = uigetdir('Select a folder');

% Check if the user clicked 'Cancel'
if selected_folder == 0
    disp('User canceled folder selection.');
else
    % Add the folder to the MATLAB path
    addpath(genpath(selected_folder));
    % Display the selected folder path
    disp(['Folder added to the MATLAB path: ' selected_folder]);
end

%Get a list of the desired files in the chosen folder
file_pattern = fullfile(selected_folder, '*.tif');
files = dir(file_pattern);



%% Start the loop

for f = 1:2:numel(files)
    
    
    %Read through two of the filenames at a time to compare the 
    % day0 and day2 images
    filename0 = files(f).name;
    fprintf('Now reading file %s\n', filename0);
    filename2 = files(f+1).name;
    fprintf('Now reading file %s\n', filename2);
    %fullFileName = fullfile(files(f).folder, filename0);

    binarized_day0 = filename0;
    binarized_day2 = filename2;

    
    %% Process images
    
    % Find the boundary for the day0 image (function 1)
    % - If boundary tracing fails, ensure that image was corrected to 
    % - remove all stray pixels that could interfere with the function. 
    % - The edge of the spheorid must be smooth and continuous.
    [boundary] = Find_Boundary_BWonly(binarized_day0);
    
    BW = imread(binarized_day0); BW2 = imread(binarized_day2);

    % Find the centroid of the spheroid clump (function 2)
    [centroid_loc, spheroid_area, centroids, areas, pixel_locs, boundary_pixel_locs] = Find_SpheroidCentroid(BW);
    [centroid_loc2, spheroid_area2, FEcentroids2, pixel_locs2, boundary_pixel_locs2, areas2, blob_centroids2] = FindSpheroidCentroidNucleiObjects(BW2);
    
    
    % Align the spheroid centroids (function 3)
    tic %Set a timer for the function
    [outer_centroids2, outer_areas2, poly_boundary, day2centered_boundary] = AlignCentroidsandFindBlobPOI(boundary,... 
        BW2, centroid_loc, centroid_loc2, blob_centroids2, boundary_pixel_locs2, areas2);
    % [outer_pixels2, poly_boundary, day2centered_boundary] = AlignCentroidsandFindPixelPOI(boundary,... 
    %     BW2, centroid_loc, centroid_loc2, pixel_locs2, boundary_pixel_locs2);
    compTime = toc
    

    %     %---------------------%
%     disp('Paused, type next to continue')
%     input('next')
%     %---------------------%
        
    %  % Close the earlier figures 
    % close (figure(1))
    % for i = 4:9
    %     close (figure(i))
    % end
    
    
    % Calculate distances and angles ---------------------
    
    % Find the distance of the outer centroids to the center spheroid centroid and to the boundary (function 4)
    tic
    disp('Calculating distances to center and boundary')
    [outer_distance_magnitude, outer_distances_xy, full_distance_magnitude, full_distances_xy, ...
        boundary_intersect, horizontal_line]  = CalculateDistancesBlobs(outer_centroids2, centroid_loc2, day2centered_boundary, BW2);    
     


    % Find the angle between the distance line and a line at x = 0 (function 5)
    % - Plots just a few pixels as an example
    [angles] = FindBlobAngles(BW2, outer_centroids2, centroid_loc2, outer_distances_xy, day2centered_boundary, horizontal_line);
    
    compTime2 = toc 
    
%     %---------------------%
%     disp('Paused, type next to continue')
%     input('next')
%     %---------------------%
        
    % Plot the distances and angles vs the areas (function 6)
   [final_pixels, Irb, Ixb, Iyb,  Irc, Ixc, Iyc, max_dist, median_dist, mean_dist, outerdistance_lengths_um, ...
    angles_array] = PlotPixelDistancesandAngles(outer_distance_magnitude, outer_distances_xy, full_distance_magnitude, full_distances_xy, angles, pixel_size);


    
    
    % Save the figures  ------------------

    
    % (1) Save as matlab figures ...................
    disp('Saving figures')
    disp(' ')


    % Create a new folder with a unique name
    spheroid_set = extractBetween(filename0,1,'_'); %requires that images start with the spheroid# and underscore
    figHandles = flip(findall(0,'Type','figure'),1);
    
    cd(selected_folder); cd('..');
    new_foldername = ['Figs expt', expt_no, ' quantified centroids sph#', spheroid_set{1},' ', condition];
    new_folderpath = fullfile(pwd, new_foldername);
    
    %cd(selected_folder); cd('..');
    mkdir(new_foldername);

    % Save each figure with a unique file name in the specified folder
    for i = 1:numel(figHandles)
        % Specify the file name for the saved figure
        fileName = ['Fig' num2str(i) ' expt', expt_no, ' ', condition, ' quantified centroids sph#', spheroid_set{1}];

        % Full file path including the folder, file name, and extension
        fullFilePath = fullfile(new_folderpath, [fileName, '.fig']);

        % Save the figure as a .fig file (MATLAB figure file)
        saveas(i, fullFilePath, 'fig');

        disp(['Figure ' num2str(i) ' saved to: ' fullFilePath]);
    end
    
    
    % % Prompt the user to select a folder for saving the figures
    % selected_folder = uigetdir('C:\', 'Select a folder for saving the figures');
    % 
    % % Check if the user clicked 'Cancel'
    % if selected_folder == 0
    %     disp('User canceled folder selection.');
    % else
    %     % Create a new folder with a unique name
    %     new_foldername = ['Figures expt', expt_no, ' quantified sph#', spheroid_set{1},' ', condition];
    %     new_folderpath = fullfile(selected_folder, new_foldername);
    %     mkdir(new_folderpath);
    % 
    %     % Save each figure with a unique file name in the specified folder
    %     for i = 1:numel(figHandles)
    %         % Specify the file name for the saved figure
    %         fileName = ['Fig' num2str(i) ' expt', expt_no, ' ', condition, ' quantified sph#', spheroid_set{1}];
    % 
    %         % Full file path including the folder, file name, and extension
    %         fullFilePath = fullfile(new_folderpath, [fileName, '.fig']);
    % 
    %         % Save the figure as a .fig file (MATLAB figure file)
    %         saveas(i, fullFilePath, 'fig');
    % 
    %         disp(['Figure ' num2str(i) ' saved to: ' fullFilePath]);
    %     end
    % 
    % end




    % (2) Save figures into a pdf file .................
    cd(new_folderpath);
    cd('..')

    % Method using the exportgraphics function (works with MATLAB R2022a)
    pdf_name = ['Expt', expt_no, ' quantified centroids sph#', spheroid_set{1},' ', condition, '.pdf'];
    disp(['Now writing: ',pdf_name]);

    exportgraphics(figHandles(1),pdf_name)
    for i = 2:numel(figHandles)
        exportgraphics(figHandles(i),pdf_name, 'append', true)
    end




    
    
    % Save the relevant data for further processing -------------
    
    %cd(new_folderpath);
    clear i
    
    disp('Saving relevant workspace variables to file explorer')
    save(['Vars expt', expt_no, ' centroids ', condition, ' sph', spheroid_set{1}], ...
        'files', 'final_pixels', 'Irb', 'Ixb', 'Iyb', 'Irc', 'Ixc', 'Iyc',...
        'outer_centroids2', 'outer_areas2',...
        'max_dist', 'median_dist', 'mean_dist', 'outerdistance_lengths_um', 'angles_array')


   
    
%     %---------------------%
%     disp('Paused, check on pdf file and saved variables. Type next to go to next loop')
%     input('next')
%     %---------------------%

%%
close all
cd(main_folder)


end

disp('Finished with all images.')
disp(' ')
disp(' ')

% ----------------------- END OF PART 2 ----
    
