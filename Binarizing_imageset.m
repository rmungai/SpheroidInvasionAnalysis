%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; April 2022
% -------------------PART 1----------------------
% For cleaning up images to prepare them for quantification in part 2


clear ; clc; close all


% (!) USER INPUT: state the experiment number and condition ------
expt_no = '16';
condition = 'static';

%Start a loop through the tif images in a specified folder -------
%myFolder = 'B:\Student folders\Rozanne Mungai\Cell stretch migration project\Spheroid migration prj results\spheroid expt7 06.07\Expt7 images for quant\3D dynamic';
% myFolder = 'C:\Users\rwmungai\Desktop\Expt12 images for quant-fixed\3D static';
myFolder = ['C:\Users\rwmungai\Desktop\Expt12-16 PixelSquaresQuickDistances\Expt', expt_no, ' images to quantify\3D ', condition];

%Check to see if the folder is connected
if ~isfolder(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder)
    uiwait(warndlg(errorMessage));
    myFolder = uigetdir(); %Ask for a new one
    if myFolder == 0
        % User clicked cancel
        return;
    end
end

%Get a list of the desired files in the chosen folder
filePattern = fullfile(myFolder, '*.tif');
files = dir(filePattern);
%files = dir('*.tif');  %old

for f = 1:2:numel(files)   

    %Read through two of the filenames at a time to compare the day0 and
    %day2 images
    day0 = files(f).name;
    fprintf('Now reading file %s\n', day0);
    day2 = files(f+1).name;
    fprintf('Now reading file %s\n', day2);
    %fullFileName = fullfile(files(f).folder, filename0);

%     % Binarize the images 
%     day0 = '5_day0_10x_CH1.tif';
%     day4 = '5_day4fixed_10x_CH1.tif';



    %% Process images
    
    %Binarize the images    
    [BW] = Binarize_Image(day0);
    [BW2] = Binarize_Image(day2);
        
    disp('Masking images with circle')
    [maskedBW] = Mask_Image(BW); %Not needed for day0 but good for consistency
    [maskedBW2] = Mask_Image(BW2);


    %Correct images for any remaining noise
    [corrected_BW] = Correct_BW(day0, maskedBW);
    [corrected_BW2] = Correct_BW(day2, maskedBW2);


    %% Save the images  

    %Save the corrected images to specified folder

    %save_cBW = 'C:\Users\rwmungai\Desktop\Expt12-16 PixelSquaresQuickDistances\Expt 14 images to quantify\3D dynamic - BW corrected\corrected_BW.tif';
    save_mcBW = ['C:\Users\rwmungai\Desktop\Expt12-16 PixelSquaresQuickDistances' ...
        '\Expt', expt_no, ' images to quantify\3D ', condition, ' - BW masked\masked_BW.tif'];  
    imwrite(corrected_BW, save_mcBW);
    save_mcBW2 = ['C:\Users\rwmungai\Desktop\Expt12-16 PixelSquaresQuickDistances' ...
        '\Expt', expt_no, ' images to quantify\3D ', condition, ' - BW masked\masked_BW2.tif'];
    imwrite(corrected_BW2, save_mcBW2);


    %---------------------%
    disp('Paused, rename the images in file explorer and close any unwanted figures. When finished type next to continue')
    input('next')
    %---------------------%


    % Save the figures into a pdf file  
    
    
    % Method using the exportgraphics function-------
    % - (works with MATLAB R2022a)
%     pdf_name = ['Expt12 Spheroid set #8 dynamic.pdf'];
    spheroid_set = extractBetween(day0,1,'_'); 
%     pdf_name = ['Expt12 binarizing spheroid set #', num2str(loop_count),' dynamic.pdf'];
    pdf_name = ['Expt',expt_no, ' binarized masked spheroid set #', spheroid_set{1},' ', condition, '.pdf'];
    disp(['Now writing: ',pdf_name]);
    figHandles = flip(findall(0,'Type','figure'),1);
    
    exportgraphics(figHandles(1),pdf_name)
    for i = 2:numel(figHandles)        
        exportgraphics(figHandles(i),pdf_name, 'append', true)
    end
    

    %---------------------%
    disp('Paused, check on pdf file and when finished type next to continue')
    input('next')
    %---------------------%

    
    %% Move to next spheroid
    %loop_count = loop_count + 1;
    close all
  
end

disp('Finished with all images!')


% ------------------------END OF PART 1 ----
    
   
