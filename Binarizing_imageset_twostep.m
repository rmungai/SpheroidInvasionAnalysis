%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; April 2022
% -------------------PART 1----------------------
% For cleaning up images to prepare them for quantification in part 2


clear ; clc; close all


% Prompt the user to input a value for a variable ------
expt_no = input('What is the experiment number?');
condition = input('What is the experiment condition?' , 's');
num_days = input('What are the number of days of the experiment?');
pixel_size = input('What is the um/pixel ratio of your images?');

% Display the specified variable value
disp(['Experiment #: ' num2str(expt_no)]);
disp(['Condition: ' num2str(condition)]);
disp(['Number of days: ' num2str(num_days)]);
disp(['Pixel size #: ' num2str(pixel_size)]);

% State the experiment number and condition ------
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
    %day 0 and day2 images
    day0 = files(f).name;
    fprintf('Now reading file %s\n', day0);
    day2 = files(f+1).name;
    fprintf('Now reading file %s\n', day2);
    %fullFileName = fullfile(files(f).folder, filename0);



    %% Process images
    
    %Binarize the images    
    [BW] = Binarize_Image(day0);
    [BW2] = Binarize_Image(day2);
        
    %Correct images for any remaining noise
    [correctedBW] = Correct_BW(day0, BW);
    [correctedBW2] = Correct_BW(day2, BW2);

    disp('Masking images with circle')
    [maskedBW] = Mask_Image_wCentroid(correctedBW); %Not needed for day0 but good for consistency
    [maskedBW2] = Mask_Image_wCentroid(correctedBW2);


    
    %% Save the images  

    %Save the corrected images to specified folder
    disp('Now saving images to specified folder')

    %Save binarized images ..................................
    % Save each image with a unique name in the specified folder
    corrected_images = {correctedBW, correctedBW2};
    for i = 1:2
        % Prompt the user to select a folder and specify a file name for saving
        disp(['Save binarized image ' num2str(i)])
        [fileName, filePath] = uiputfile('*.tif', 'Save binarized TIFF Image As');

        % Check if the user clicked 'Cancel'
        if fileName == 0
            disp('User canceled file saving.');
        else
            % Display the selected file name and path
            disp(['Selected file name: ' fileName]);
            disp(['Selected file path: ' filePath]);
            fullFilePath = fullfile(filePath, fileName);
            imwrite(corrected_images{i}, fullFilePath, 'tif');
            disp(['Binarized image saved to: ' fullFilePath]);
        end
    end




    %Save masked images ..................................
    % Save each image with a unique name in the specified folder

    masked_images = {maskedBW, maskedBW2};
    for i = 1:2
        % Prompt the user to select a folder and specify a file name for saving
        disp(['Save masked image ' num2str(i)])
        [fileName, filePath] = uiputfile('*.tif', 'Save masked image TIFF Image');

        % Check if the user clicked 'Cancel'
        if fileName == 0
            disp('User canceled file saving.');
        else
            % Display the selected file name and path
            disp(['Selected file name: ' fileName]);
            disp(['Selected file path: ' filePath]);
            fullFilePath = fullfile(filePath, fileName);
            imwrite(masked_images{i}, fullFilePath, 'tif');
            disp(['Masked image saved to: ' fullFilePath]);
        end
    end



    %% Save the figures

    % Method using the exportgraphics function - (works with MATLAB R2022a)
    spheroid_set = extractBetween(filename0,1,'_');
    pdf_name = ['Expt',expt_no, ' binarized masked sph#', spheroid_set{1},' ', condition, '.pdf'];
    disp(['Now writing: ',pdf_name]);
    figHandles = flip(findall(0,'Type','figure'),1);

    exportgraphics(figHandles(1),pdf_name)
    for i = 2:numel(figHandles)
        exportgraphics(figHandles(i),pdf_name, 'append', true)
    end
    

    %---------------------%

%     disp('Paused, check on pdf file and when finished type next to continue')
    disp('Paused, check on images and pdf in file explorer.')
    disp('When finished type next to continue')
    input('next')
    %---------------------%

    
    %% Move to next spheroid
    close all
  
end

disp('Finished with all images!')


% ------------------------END OF PART 1 ----
    
   
