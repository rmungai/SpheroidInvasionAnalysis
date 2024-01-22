%% Image quantification MATLAB script for 3D spheroid migration
% Author: Rozanne W. Mungai 
% - Billiar Lab, Worcester Polytechnic Institute
% Created April 2022, Published January 2024
%
% ------- PART 1 of image quantification script set ---------
% 
% Requirements: Initial and final greyscale 8-bit tiff (.tif) images of multicellular spheroids
% - For best results, use images that have been pre-processed to increase contrast
% and reduce noise
% - To accomodate automatic file saving, keep track of the spheroids by number 
% and note the number in the beginning of the image name followed by an underscore 
% such as: [Spheroid #]_[...] Example: "1_day0_10x_CH1_8bit.tif"
% - For organization purposes use on one experiment condition at a time
%
% Purpose: Binarize and correct images to prepare them for quantification in part 2
%
% Outputs: Binarized images and a pdf file demonstrating workflow
%


clear ; clc; close all


% Prompt the user to input a value for a variable ------
expt_no = input('What is the experiment number?  ');
condition = input('What is the experiment condition?  ' , 's');
num_days = input('What are the number of days of the experiment?  ');
%pixel_size = input('What is the um/pixel ratio of your images?');

% Display the specified variable value
disp(['Experiment #:  ' num2str(expt_no)]);
disp(['Condition:  ' num2str(condition)]);
disp(['Number of days:  ' num2str(num_days)]);
%disp(['Pixel size #: ' num2str(pixel_size)]);
disp(' ');


% % State the experiment number and condition ------ %Use if preferred over prompt
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

main_folder = pwd;

% Prompt the user to select the folder that contains the grayscale 8-bit
% images for loading
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


% Create a new folder for saving new binarized images
% newFolderName = 'Binarized images';
% newFolderPath = fullfile(selectedFolder, newFolderName);
new_image_folder = ['Binarized',  '_E', num2str(expt_no), '_', condition];
mkdir(new_image_folder);

% Add the folder to the MATLAB path
addpath(new_image_folder);


%% Start the loop 

for f = 1:2:numel(files) 
    
    cd(main_folder);

    %Read through two of the filenames at a time to compare the
    %day 0 and day2 images
    day0 = files(f).name;
    fprintf('Now reading file: %s\n', day0);
    day2 = files(f+1).name;
    fprintf('Now reading file: %s\n', day2);
    %fullFileName = fullfile(files(f).folder, filename0);



    %% Process images
    
    %Binarize the images    
    [BW] = Binarize_Image(day0);
    [BW2] = Binarize_Image(day2);
        
    %Correct images for any remaining noise using a custom GUI
    % - It is especially important to remove stray pixels for images that
    % - will undergo boundary tracing. The edge of the spheorid must be
    % - smooth and continuous for the function to work
    [correctedBW] = Correct_BW(day0, BW);
    [correctedBW2] = Correct_BW(day2, BW2);

    disp('Masking images with circle')
    [maskedBW] = Mask_Image_wCentroid(correctedBW); %Not needed for day0 but good for consistency
    [maskedBW2] = Mask_Image_wCentroid(correctedBW2);


    
    %% Save the images  

    %Save the corrected images to specified folder
    cd(new_image_folder)
    disp(' ')
    disp('Now saving binarized images to specified folder')

    %Save binarized images ..................................
    % Save each image with a unique name in the specified folder
    new_images = {correctedBW, correctedBW2, maskedBW, maskedBW2};
    new_image_names = {'BW1', 'BW2', 'maskedBW1', 'maskedBW2'};

    %Automatically rename images
    % - This requires that the grayscale images were already named with the 
    % spheroid# followed by an underscore such as: 
    % - - [Spheroid #]_[...] Example: "1_day0_10x_CH1_8bit.tif"
    % - Can comment out if desired - will need to rename manually to avoid
    % overwritting in next loop

    spheroid_set = extractBetween(day0,1,'_'); %requires that images start with the spheroid# and underscore
    for i = 1:4
        % full_image_name = ['Expt', num2str(expt_no), '_', new_image_names{i}, '_Sph', spheroid_set{1}, '.tif'];
        full_image_name = [spheroid_set{1}, '_', new_image_names{i}, '_E', num2str(expt_no), '_', condition, '.tif'];
        imwrite(new_images{i}, full_image_name);
        disp([' - Binarized image saved to: ' pwd]);    
    end




    %% Save the figures
    
    cd(main_folder)

    % Method using the exportgraphics function - (works with MATLAB R2022a+)
    pdf_name = ['Expt', num2str(expt_no), ' binarized masked sph#', spheroid_set{1},' ', condition, '.pdf'];   
    disp(['Now writing: ',pdf_name]);
    figHandles = flip(findall(0,'Type','figure'),1);

    exportgraphics(figHandles(1),pdf_name)
    for i = 2:numel(figHandles)
        exportgraphics(figHandles(i),pdf_name, 'append', true)
    end
    

    %---------------------%

    disp('Paused, check on images and pdf in file explorer.')
    disp('When finished type next to continue')
    input('next')
    
    %---------------------%

    
    %% Move to next spheroid
    disp(' ')
    close all
  
end

disp('Finished with all images!')


% ----------------------- END OF PART 1 ----
    
   
