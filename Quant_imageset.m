%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; April 2022

% -------------------PART 2----------------------
%---------- USE ON BINARIZED IMAGES  ------------

% - For calculating all the pixels instead of centroids, uses squares to pass
% - through the isinterior function more quickly
% - Calculates the distances of migrating cells mathematically for speed


clear ; clc; close all

%% Prompt the user to input a value for a variable ------
expt_no = input('What is the experiment number?');
condition = input('What is the experiment condition?' , 's');
num_days = input('What are the number of days of the experiment?');
pixel_size = input('What is the um/pixel ratio of your images?');

% Display the specified variable value
disp(['Experiment #: ' num2str(expt_no)]);
disp(['Condition: ' num2str(condition)]);
disp(['Number of days: ' num2str(num_days)]);
disp(['Pixel size #: ' num2str(pixel_size)]);

% % State the experiment number and condition ------
% expt_no = '18';
% condition = 'static';
% 
% % State length of experiment (days) and image pixel size
% 
% % Comparing day 2 to day 0 for now
% num_days = 2;
% 
% %Experiment 12 images captured at 10X on the Keyence microscope
% % - the pixel size is 0.75488 um/pixel
% pixel_size = 0.75488; %um/pixel


%% Set up folder to obtain images

% Prompt the user to select a folder
disp('Select a folder to import images.')
selectedFolder = uigetdir('C:\', 'Select a folder');

% Check if the user clicked 'Cancel'
if selectedFolder == 0
    disp('User canceled folder selection.');
else
    % Display the selected folder
    disp(['Selected folder: ' selectedFolder]);
end


%Get a list of the desired files in the chosen folder
filePattern = fullfile(selectedFolder, '*.tif');
files = dir(filePattern);


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
    %[boundary] = Find_Boundary(day0, BW);
    [boundary] = Find_Boundary_BWonly(binarized_day0);
    
    BW = imread(binarized_day0); BW2 = imread(binarized_day2);

    % Find the centroid of the spheroid clump (function 2)
    [centroid_loc, spheroid_area, centroids, areas, pixel_locs, boundary_pixel_locs] = Find_SpheroidCentroid(BW);
    [centroid_loc2, spheroid_area2, centroids2, areas2, pixel_locs2, boundary_pixel_locs2] = Find_SpheroidCentroid(BW2);
    
    
    % Align the spheroid centroids (function 3)
    tic %Set a timer for the code
    [outer_pixels2, poly_boundary, day2centered_boundary] = AlignCentroidsandFindPixelPOI(boundary,... 
        BW2, centroid_loc, centroid_loc2, pixel_locs2, boundary_pixel_locs2);
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
    
    
    %% Calculate distances and angles
    
    % Find the distance of the outer centroids to the center spheroid centroid and to the boundary (function 4)
    tic
    disp('Calculating distances to center and boundary')
    [outer_distance_magnitude, outer_distances_xy, full_distance_magnitude, full_distances_xy, ...
        boundary_intersect, horizontal_line]  = CalculateDistances(outer_pixels2, centroid_loc2, day2centered_boundary, BW2);    
     


    % Find the angle between the distance line and a line at x = 0 (function 5)
    % - Plots just a few pixels as an example
    [angles] = FindPixelAngles(BW2, outer_pixels2, centroid_loc2, outer_distances_xy, day2centered_boundary, horizontal_line);
    
    compTime2 = toc 
    
%     %---------------------%
%     disp('Paused, type next to continue')
%     input('next')
%     %---------------------%
        
    % Plot the distances and angles vs the areas (function 6)
   [final_pixels, Irb, Ixb, Iyb,  Irc, Ixc, Iyc, max_distance, median_distance, mean_distance, ...
       speedum_array, angles_array] = PlotPixelDistancesandAngles(outer_distance_magnitude, outer_distances_xy, ...
       full_distance_magnitude, full_distances_xy, angles, num_days, pixel_size);


    
    
    %% Save the figures  

    
    % (1) Save as matlab figures ...................

    spheroid_set = extractBetween(filename0,1,'_');
    figHandles = flip(findall(0,'Type','figure'),1);

    % Prompt the user to select a folder for saving the figures
    selectedFolder = uigetdir('C:\', 'Select a folder for saving the figures');

    % Check if the user clicked 'Cancel'
    if selectedFolder == 0
        disp('User canceled folder selection.');
    else
        % Create a new folder with a unique name
        newFolderName = ['Figures expt',expt_no, ' quantified sph#', spheroid_set{1},' ', condition];
        newFolderPath = fullfile(selectedFolder, newFolderName);
        mkdir(newFolderPath);

        % Save each figure with a unique file name in the specified folder
        for i = 1:numel(figHandles)
            % Specify the file name for the saved figure
            fileName = ['Fig' num2str(i) ' expt',expt_no, ' ', condition, ' quantified sph#', spheroid_set{1}];

            % Full file path including the folder, file name, and extension
            fullFilePath = fullfile(newFolderPath, [fileName, '.fig']);

            % Save the figure as a .fig file (MATLAB figure file)
            saveas(i, fullFilePath, 'fig');

            disp(['Figure ' num2str(i) ' saved to: ' fullFilePath]);
        end
    end



    % (2) Save figures into a pdf file .................

    % Method using the exportgraphics function (works with MATLAB R2022a)
    pdf_name = ['Expt',expt_no, ' quantified sph#', spheroid_set{1},' ', condition, '.pdf'];
    disp(['Now writing: ',pdf_name]);

    exportgraphics(figHandles(1),pdf_name)
    for i = 2:numel(figHandles)
        exportgraphics(figHandles(i),pdf_name, 'append', true)
    end




    
    
    %% Save the relevant data for further processing

    disp('Saving relevant workspace variables to file explorer')
    save(['Vars w mask- expt', expt_no, ' ', condition, ' sph', spheroid_set{1}], ...
        'final_pixels', 'Irb', 'Ixb', 'Iyb', 'Irc', 'Ixc', 'Iyc', 'areas', 'areas2',...
        'max_distance', 'median_distance', 'mean_distance', 'speedum_array', 'angles_array')


   
    
%     %---------------------%
%     disp('Paused, check on pdf file and saved variables. Type next to go to next loop')
%     input('next')
%     %---------------------%

close all

%     loop_count = loop_count + 1;

end

disp('Finished with all images.')
disp(' ')
disp(' ')


