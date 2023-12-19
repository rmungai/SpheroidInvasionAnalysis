%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; April 2022

function [image_stats] = FEprops(binary_image) 
% This function divides up the image into square finite elements and computes the 
% areas, centroids and pixel locations of each


%Attempt to deal with the really large spheroid pixel issue
% - break up the binary image into finite elements (ex. 100x100)
Nsubsets = 45; %52, 60 - %previous values
subsize_x = ceil(size(binary_image,1)/Nsubsets);
subsize_y = ceil(size(binary_image,2)/Nsubsets);

Area = zeros(Nsubsets^2, 1);
Centroid = zeros(Nsubsets^2, 2);
PixelList = cell(Nsubsets^2, 1);
BoundaryPixelList = cell(Nsubsets^2,1);

for i = 1:Nsubsets
    for j=1:Nsubsets

        %Capture i_th and j_th 20 values
        x_index = (i-1)*subsize_x + (1:subsize_x);
        y_index = (j-1)*subsize_y + (1:subsize_y);
        
        
        %Accomodate for end cases when there are fewer pixels
        % - if the index is larger than the image  dim, then use 
        % - the image size as the end point

        % - cases for rows
        if x_index(end) > size(binary_image,1)
            x_index = x_index(1):size(binary_image,1);
        end
        
        % - cases for columns
        if y_index(end) > size(binary_image,2)
            y_index = y_index(1):size(binary_image,1);
        end

        if (isempty(y_index)) || (isempty(x_index))
            continue
        end


        
        %Calculate values
        iter_pixels = binary_image(x_index,y_index);
        iter_area = sum(sum(iter_pixels));
        
        %Compute weighted average to get centroid
        x_sum = sum(iter_pixels, 2)';
        y_sum = sum(iter_pixels, 1);
        iter_centroid = [sum(y_index .* y_sum) / (sum(y_sum)); sum(x_index .* x_sum) / (sum(x_sum))];

        %Store pixel locations of non-zero pixels
        iter_pixel_list = zeros(iter_area, 2);
        pix_ind = 1;
        for x_ind = 1:length(x_index)
            for y_ind = 1:length(y_index)
                if binary_image(x_index(x_ind),y_index(y_ind))
                    iter_pixel_list(pix_ind, :) = [y_index(y_ind), x_index(x_ind)];
                    pix_ind = pix_ind + 1;
                end
            end
        end


        %Define the element edge points for later use
        % - Allows for faster pixel processing 
        x_edge_inds = x_index(1:10:end);
        y_edge_inds = y_index(1:10:end);

        edge1 = [y_index(1)*ones(length(x_edge_inds),1), x_edge_inds'];
        edge2 = [y_edge_inds', x_index(1)*ones(length(y_edge_inds),1)];
        edge3 = [y_index(end)*ones(length(x_edge_inds),1), x_edge_inds'];
        edge4 = [y_edge_inds', x_index(end)*ones(length(y_edge_inds),1)];
        last_point = [y_index(end), x_index(end)]; % The slicing by every 10 discludes the final end point if its not evenly spaced
        iter_edge_pixels =vertcat(edge1, edge2, edge3, edge4, last_point);
        

%         %Plotting element edges for debugging 
%         %close all
%         figure
%         imshow(binary_image)
%         hold on
%         plot(iter_edge_pixels(1), iter_edge_pixels(2), 'rx')
%         plot(iter_centroid(1), iter_centroid(2), 'b*')
%         hold off
%         %pause
%           
%       %Plotting individual centroids for debugging 
%         if iter_area > 0
%             %close all
%             figure();
%             imshow(binary_image(x_index,y_index))
%             hold on
%             plot(iter_centroid(2) - y_index(1), iter_centroid(1) - x_index(1), 'rx')
%             pause
%         end

        %Assign values to variables 
        ind = sub2ind([Nsubsets,Nsubsets], i, j); %converts indices to subscripts
        Area(ind) = iter_area;
        Centroid(ind, :) = iter_centroid;
        PixelList{ind, 1} = iter_pixel_list;
        BoundaryPixelList{ind, 1} = iter_edge_pixels;

               
    end
end


%Filter the results - only keep non-zero area values
area_mask = Area > 0;
Area = Area(area_mask);
Centroid = Centroid(area_mask, :);
PixelList = PixelList(area_mask);
BoundaryPixelList = BoundaryPixelList(area_mask);

%Assign to a table
image_stats = table(Area, Centroid, PixelList, BoundaryPixelList);




% %Plotting element edges for debugging 
% %close all
% figure
% imshow(binary_image)
% hold on
% plot(BoundaryPixelList{1}(:,1), BoundaryPixelList{1}(:,2), 'rx')
% plot(BoundaryPixelList{end/2}(:,1), BoundaryPixelList{end/2}(:,2), 'rx')
% plot(BoundaryPixelList{end-2}(:,1), BoundaryPixelList{end-2}(:,2), 'rx')
% hold off
% title('Checking finite elements')



