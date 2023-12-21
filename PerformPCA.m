
function [principle_angles, principle_speeds, Irb, Ixb, Iyb, transformed_angles, transformed_speeds] = PerformPCA(angles, speeds, num_days, pixel_size)

% This function reads performs principle component analysis (PCA) on spheroid persistence speed data
% 
% Image quantification MATLAB script for 3D spheroid migration
% Rozanne Mungai Billiar Lab; September 2023


%% Perform PCA for all spheroids in expt 

% (!) USER INPUT: load the compiled dynamic and static variables 
%   - for each expt (with individual spheroid persistent speed data)

% Initialize cells to store results
principle_angles = zeros(length(speeds),2);
principle_speeds = zeros(length(speeds),2);
transformed_angles = cell(size(speeds));
transformed_speeds = cell(size(speeds));
transformed_outerdistance_lengths = cell(size(speeds));
transformed_outerdistances_xy = cell(size(speeds));

Irb = zeros(length(speeds),1);
Ixb = zeros(length(speeds),1);
Iyb = zeros(length(speeds),1);

% Begin loop through number of spheroids in expt
for i = 1:size(speeds,2)

    %Convert polar coordinate system back to xy-cartesian ............
    % - angles are in units of radians
    velocity = zeros(length(angles{i}), 2);
    velocity(:,1) = speeds{i}.*cos(angles{i});
    velocity(:,2) = speeds{i}.*sin(angles{i});


    % Calculate PCA of data ..........................................
    % - coeff: principle component directions (eigenvectors)
    % - - each column of coeff contains coefficients for one principal component
    % - score: transformed data (velocities) in the principle component space
    % - latent: magnitude of variance in data (eigenvalues)
    
    [coeff, score, latent] = pca(velocity);

    % - pca function scales data to have unit variance 

    
    %Convert transformed velocities to angles and speeds ............
    transformed_angles{i} = atan2(score(:,2),score(:,1)); 
    transformed_speeds{i} = sqrt((score(:,2)).^2 + (score(:,1)).^2);


    % Convert results to principle angles and speeds ..................
    % - Calc principle angles in degrees 
    prin_angle1 = wrapTo360(atan2d(coeff(2,1),coeff(1,1)));
    prin_angle2 = wrapTo360(atan2d(coeff(2,2),coeff(1,2)));

    % - Calc mean principle speeds at the principle angles
    prin_speed1 = mean(abs(score(:,1)));
    prin_speed2 = mean(abs(score(:,2)));

    %Assign final variables to new array ...............................
    % - Larger differences along the prin speeds means there is a large
    % difference in invasion directions
    principle_angles(i,:) = [prin_angle1, prin_angle2]; 
    principle_speeds(i,:) = [prin_speed1, prin_speed2];

    


    %% Plot the pixels along the prinicple angles .........
        
    % - Persistance speed (um/min) from boundary vs angle values polar plot
    %---essentially the same as distance plot
    
    
    % Plot original data . . . . . . . . . . . . . . . . . 
    figure

    % - plot pixels - - -
    
    polarplot(angles{i}, speeds{i}, '.') 
    title ('Persistence speed (um/min) vs migration angle')
    
    % - Set figure size: 
    % - https://www.mathworks.com/help/matlab/ref/figure.html#buich1u-1_sep_shared-Position
    set(gca,'Fontname','arial', 'FontSize',14, 'OuterPosition', [0 0.2 1 0.75]);


    % - Add annotation about PCA
    annstr = {strcat('Principle angles: (', num2str(principle_angles(i,:)), ')') , ...
        strcat('Mean principle speeds: (', num2str(principle_speeds(i,:)), ')')} ; 
    annpos = [0.20 0.08 0.5 0.1]; % annotation position in figure coordinates
    ann = annotation('textbox',annpos,'string',annstr, 'FitBoxtoText', 'on', 'EdgeColor', 'none', 'FontSize', 14);

    

    % - plot principle angles - -
    hold on

    a1 = deg2rad( [principle_angles(i,1), principle_angles(i,1)]);
    s1 = [-max(speeds{i}(:,1)) max(speeds{i}(:,1))];
    a2 = deg2rad( [principle_angles(i,2), principle_angles(i,2)]);
    s2 = [-max(speeds{i}(:,1)) max(speeds{i}(:,1))];
    polarplot(a1, s1, "b", a2, s2, "k") 
    
    hold off

    %legend('', 'Principle', 'Secondary', 'Location', 'bestoutside', 'Orientation','horizontal')
    

    % Plot transformed data  . . . . . . . . . . . . . . . . . 
    figure
    polarplot(transformed_angles{i}, transformed_speeds{i}, '.') 
    title ('Transformed persistence speed (um/min) vs migration angle')
    set(gca,'Fontname','arial', 'FontSize',14, 'OuterPosition', [0 0.2 1 0.75]);
    
    hold on

    a3 = deg2rad([0 0]);
    s3 = [-max(speeds{i}(:,1)) max(speeds{i}(:,1))];
    a4 = deg2rad([90 90]);
    s4 = [-max(speeds{i}(:,1)) max(speeds{i}(:,1))];
    polarplot(a3, s3, "b", a4, s4, "k") 
    
    
    
    

    %% Compute New Distances and Directional Moment of inertia after Transformation

    %Calculate distances from boundary in pixels
    
    transformed_outerdistance_lengths{i} = ((transformed_speeds{i})*(num_days*24*60) )./pixel_size;
    %principle_outer_distances = ((principle_speeds)*(num_days*24*60) )./pixel_size;
    transformed_outerdistances_xy{i} = (score*(num_days*24*60) )./pixel_size;



    %Calculate moments of inertia from boundary
    a = 1; %area for calculation - in this case = 1 bc pixels
    Irb(i) = sum(transformed_outerdistance_lengths{i}.^2 * a);
    Ixb(i) = sum(transformed_outerdistances_xy{i}(:,2).^2 * a);
    Iyb(i) = sum(transformed_outerdistances_xy{i}(:,1).^2 * a);



end 

disp('PCA complete')


end


