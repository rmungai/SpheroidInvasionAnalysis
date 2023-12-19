function [distance_magnitude,boundary_xint,boundary_yint] = IntersectionDistance(outer_pixels, centroid_loc, boundary)
% IntersectionDistance finds the minimum distance from the Day0 boundary to a point of interest (POI).  
% The POI is on a line between the spheroid centroid (centroid_loc, x0) and the invaded cell pixels (outer_pixels, x1).
% The function zeros the coordinate system at x0. Each point should be arranged as point = [x_loc; y_loc]
% Outerpixels is fed in as one {cell} at a time

% Define coordinates and center everything along the centroid location to make calculations
% easier
x0 = centroid_loc(1); y0 = centroid_loc(2);
x1 = outer_pixels(:,1)' - x0; y1 = outer_pixels(:,2)' - y0; % a (1 x N) array
xb = boundary(:,1) - x0; yb = boundary(:,2) - y0; % a (M x 1) array

% Reshape to utilize vector operations
N = length(x1); % number of pixels
M = length(yb); % number of boundary points

xb_reshaped = repmat(xb, 1, N); % shape M, N = (MxN) array
yb_reshaped = repmat(yb, 1, N); % shape M, N
x1_reshaped = repmat(x1, M, 1); % shape M, N
y1_reshaped = repmat(y1, M, 1); % shape M, N

% Define slopes
m = y1_reshaped ./ x1_reshaped; % shape M, N

% Calculate the minimum distance from each boundary point to each line
x_min = (xb_reshaped + m .* yb_reshaped) ./ (1 + m.^2); % shape M, N
y_min = m .* x_min; % shape M, N
d = sqrt((xb_reshaped - x_min).^2 + (yb_reshaped - y_min).^2); % shape M, N


% Filter out the parts of the boundary that are unwanted --------------- %

% - Part 1: The half of the boundary that is on the opposite side from POI
%  - not nearest the POI
perp_x1 = 1;
perp_x2 = -1;
perp_y1 = (-1 ./ m);
perp_y2 = (1 ./ m);
perp_valb = (xb_reshaped - perp_x1) .* (perp_y2 - perp_y1) - (yb_reshaped - perp_y1) .* (perp_x2 - perp_x1);
perp_val_locs = (x1_reshaped - perp_x1) .* (perp_y2 - perp_y1) - (y1_reshaped - perp_y1) .* (perp_x2 - perp_x1);
perp_mask = (perp_valb ./ abs(perp_valb)) ~= (perp_val_locs ./ abs(perp_val_locs));

% - Part 2: Filters out parts of boundary that are overlapping/ further from
% - the centroid than the POI
dist_mask = (xb_reshaped.^2 + yb_reshaped.^2) > (x1_reshaped.^2 + y1_reshaped.^2);

% - Part 3: Apply filters
tot_mask = logical(perp_mask + dist_mask);
d(tot_mask) = max(max(d));

% -------------------------------------------------------------------- %


% Find the intercept by finding the boundary point closest to the line
[~, close_inds] = min(d, [], 1); % shape 1, N

% calculate the distance magnitude
xb_close = xb(close_inds); % (Nx1) 
yb_close = yb(close_inds); % (Nx1)
distance_magnitude = sqrt((x1' - xb_close).^2 + (y1' - yb_close).^2); % shape N, 1

%Un-centering the coorinates so they line up with the image again
boundary_xint = xb_close + x0; % shape N, 1
boundary_yint = yb_close + y0; % shape N, 1


end