
function [corrected_BW] = Correct_BW(image, BW)
% This function reads in a grayscale image and its binarized version and
% allows the user to remove noisy pixels to enhance to image.
%
% TO DO: Make sure you understand what gca is doing. Make the BW image pop
% up next to the gray scale one so you know what to cut out

%Begin process for removing noisy pixels
% figure
% imshow(image)

corrected_BW = BW;

disp('Image correction 1: Draw circles around pixels you want to DELETE.')
disp('Click any spot to finish')

figure

% Set up initial variables
keep_editing = true;
mask_stack = {};  % initialize an empty mask stack

% Loop until user is done editing
while keep_editing
    % Display the image and allow user to create a mask
    imshow(corrected_BW)
    h = imfreehand(gca); 
    mask = logical(createMask(h) .* BW);
    %sum(sum(mask))
    corrected_BW(mask) = 0;  % apply the mask to the image
    
    if sum(any(mask)) > 0
        mask_stack{end+1} = mask;  % add only non-empty masks to the mask stack
    end
    
    % Check if the user is done editing
    if sum(sum(mask)) == 0
        % Determine if undo option should be enabled
        undo_enabled = numel(mask_stack) > 0;
        undo_option = "";
        if undo_enabled
            undo_option = "/undo";
        end
        
        % Ask the user if they want to keep editing or quit
        keep_running_str = input("Keep editing? (y/n/restart" + undo_option + "): ", "s");
        
        % Handle user's choice
        if keep_running_str == "n"
            keep_editing = false;
        elseif keep_running_str == "restart"
            % If user wants to restart, reset the image and mask stack
            corrected_BW = BW;
            mask_stack = {};
        elseif keep_running_str == "undo" && undo_enabled
            % If user wants to undo and undo is enabled, undo the last mask
            last_mask = mask_stack{end};
            corrected_BW(last_mask) = 255;
            mask_stack = mask_stack(1:end-1);
            disp("Undo successful.");
        end
    end
end



disp('Image correction 2: Draw circles around pixels you want to ADD.')
disp('Click any spot to finish')

%figure
% Set up initial variables
keep_editing = true;
mask_stack = {};  % initialize an empty mask stack

% Loop until user is done editing
while keep_editing
    % Display the image and allow user to create a mask
    imshow(corrected_BW)
    h = imfreehand(gca); 
    %mask = logical(createMask(h) .* BW);
    mask = createMask(h);
    %sum(sum(mask))
    corrected_BW(mask) = 255;  % apply the mask to the image
    
    if sum(any(mask)) > 0
        mask_stack{end+1} = mask;  % add only non-empty masks to the mask stack
    end
    
    % Check if the user is done editing
    if sum(sum(mask)) == 0
        % Determine if undo option should be enabled
        undo_enabled = numel(mask_stack) > 0;
        undo_option = "";
        if undo_enabled
            undo_option = "/undo";
        end
        
        % Ask the user if they want to keep editing or quit
        keep_running_str = input("Keep editing? (y/n/restart" + undo_option + "): ", "s");
        
        % Handle user's choice
        if keep_running_str == "n"
            keep_editing = false;
        elseif keep_running_str == "restart"
            % If user wants to restart, reset the image and mask stack
            corrected_BW = BW;
            mask_stack = {};
        elseif keep_running_str == "undo" && undo_enabled
            % If user wants to undo and undo is enabled, undo the last mask
            last_mask = mask_stack{end};
            corrected_BW(last_mask) = 0;
            mask_stack = mask_stack(1:end-1);
            disp("Undo successful.");
        end
    end
end


% %Display the new image
% figure
% imshow(corrected_BW)
% %imshowpair(image, corrected_BW, 'montage')


end





% % OLD VERSION WITHOUT UNDO OPTION
% function [corrected_BW] = Correct_BW(image, BW)
% % This function reads in a grayscale image and its binarized version and
% % allows the user to remove noisy pixels to enhance to image.
% %
% % TO DO: Make sure you understand what gca is doing. Make the BW image pop
% % up next to the gray scale one so you know what to cut out
% 
% %Begin process for removing noisy pixels
% figure
% imshow(image)
% 
% corrected_BW = BW;
% keep_editing = true;
% 
% disp('Image correction 1: Draw circles around pixels you want to DELETE.')
% disp('Click any spot to finish')
% 
% figure
% while keep_editing
% %     imshowpair(image, corrected_BW, 'montage')
%     imshow(corrected_BW)
%     h = imfreehand(gca); 
%     mask = createMask(h);
%     corrected_BW(mask) = 0;
%     if sum(sum(mask)) == 0
%         keep_running_str = input("Keep editing? (y/n/restart): ", "s");
%         if keep_running_str == "n"
%             keep_editing = false;
%         elseif keep_running_str == "restart"
%             corrected_BW = BW;
%         end
%     end
% end
% 
% 
% 
% disp('Image correction 2: Draw circles around pixels you want to ADD.')
% disp('Click any spot to finish')
% 
% figure
% keep_editing = true;
% while keep_editing
% %     imshowpair(image, corrected_BW, 'montage')
%     imshow(corrected_BW)
%     h = imfreehand(gca); 
%     mask = createMask(h);
%     corrected_BW(mask) = 255;
%     if sum(sum(mask)) == 0
%         keep_running_str = input("Keep editing? (y/n/restart): ", "s");
%         if keep_running_str == "n"
%             keep_editing = false;
%         elseif keep_running_str == "restart"
%             corrected_BW = BW;
%         end
%     end
% end
% 
% % %Display the new image
% % figure
% % imshow(corrected_BW)
% % %imshowpair(image, corrected_BW, 'montage')
% 
% 
% end