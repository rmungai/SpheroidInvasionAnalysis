%% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; April 2022

function [boundary] = Find_Boundary_BWonly(BW)
% This function reads in an image and returns a binarized version of it and
% also traces the boundary of the image. 

I = imread(BW);

%Determine the row and column coordinates of a pixel on the border of the
%object you want the tracing to start with

[row, col] = find(I,1);

%dim = size(I);
%col = round(dim(2)/2)+10;  
%row = min(find(I(:,col)) );



%Trace the boundary starting with the specified point
% ----function reqs: binary image, row and column coor, direction of
% tracing (ex. N = north)
boundary = bwtraceboundary(I, [row,col], 'N');
boundary = [boundary(:,2), boundary(:,1)];

%Plot the border on the image
figure
imshow(I)
hold on;
% plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 3);
plot(boundary(:,1), boundary(:,2), 'g', 'LineWidth', 3);
axis('on', 'image');
title('Initial spheroid with boundary')
hold off







