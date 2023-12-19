% This function detects outliers in a dataset using the MATLAB isoutlier()
% function 
% - (Currently set to remove outliers using the default 3 median absolute
% deviations from the median.)
% It then, removes the outliers from the array by first setting them to
% zero and then deleting them


function [data_corrected, outliers] = deleteoutliers(data)
    outliers = isoutlier(data);
    outliers2 = abs(outliers-1);
    data_zeroed = data.*outliers2;
    data_corrected = data_zeroed;
    data_corrected (data_corrected == 0) = [];
end

