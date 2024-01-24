# SpheroidInvasionAnalysis


**DOI** *(will be entered here when paper is published)*

This repository contains scripts used to batch process images of multicellular spheroids and quantify invasion between two snapshot images. It is intended for cases where the same spheroid is imaged at an initial timepoint (such as Day0, when no invasion has occured) and again imaged at a final timepoint (such as Day 2) to calculate the extent of invasion from the spheroid. Please see the following manuscript for a use-case example:

(Copies of the script are provided in both Python and MATLAB for ease-of-use.) 

## **Requirements**
MATLAB R2021a or later with the image processing toolbox

## **Components**

(Optional) Binarizing_imageset_two step.m used to autimatically binarized gray scale 8-bit tiff images and apply a circular mask around the image edges. manually adjust contrast raw tif images and embed necessary metadata.

UseQuant_imagesetrocessImages.m to quantify invasion using two sets of images per spheroid: (1) initial and (2) final time points

(Optional) ConsolidateData2.m compiles the data from all spheroids into one file (for organization) and CompilingResultsMultiExpt.mcompiles spheroid data for multiple experiments together in one file


## **Pipeline**

1. Binarizing_imageset_two step.m This script takes in gray scale 8-bit tiff images and automatically binarizes and masks the images. A circular mask is applied around the spheroids for consistency since, in cases of abundant invasion, the rectangular image frame can skew invasion results. Manual image correction is provided as an option in case further image processing is needed. This script is optional since binarizing and masking can be performed manually using FIJI if desired. It is recommended that constrast enhancing is performed before running this script to make automatic binarizing simpler.

Function tree:
  * Binarize_image.m
  * Correct_BW.m
  * Mask_Image_wCentroid.m
  * Find_SpheroidCentroid.m

2. Use **Quant_imageset.m** to quantify invasion using two sets of images per spheroid: (1) initial and (2) final time points. 

Takes in binarized images and traces the boundary of the Day 0 image and overlays that boundary over the final time point image. The distances and angles of all pixels (aka. cells) at the final time point that have invaded past the boudary are calculated in reference to both the boundary as well as the center of the spheroid (see Figure 1). Next, invasion metrics are calculated: area change, distance and persistence speed from boundary and center, area moment of inertia. 

The variables are saved in a ".mat" file and the figures are saved as ".fig" files as well as compiled into a pdf document. It is recommended to use the "Binarizing_imageset_two step.m" to generate binarized and circle masked images. In particular, the Day 0 images must not have stray pixels since that can interfere with boundary tracing. 

To accomodate automatic file saving, keep track of the spheroids by number and note the number in the beginning of the image name followed by an underscore such as: [Spheroid #]_[...]
Example: "1_day0_maskedBW_E1.tif"

  Function tree:
    * Find_Boundary_BWonly.m
    * Find_SpheroidCentroid.m
    * FEprops.m
    * AlignCentroidsandFindPixelsPOI.m
    * CalculateDistances.m
    * IntersectionDistance.m
    * FIndPixelAngles.m
    * PlotPixelDistancesandAngles.m
  
3. If the user desires to compile the data obtained in "Quant_imageset.m" for all the spheroids into one ".mat" file, **ConsolidateData2.m** is included for that purpose. The consolidated data can then be extracted by the user for further analysis as desired. 

4. **PCA_script.m** performes Principle Component Analysis on the spheroid invasion data of one experiment in order to quantify invasion directionality trends. Load a ".mat" file that was saved using "ConsolidateData2.m." The script will transform the persistence speeds along the principle angles as well as calculate the transformed area moment of inertia. The variables are saved in a ".mat" file and the figures are saved as ".fig" files as well as compiled into a pdf document.
Calls on PerformPCA.m


Authors
Rozanne W. Mungai
Department of Biomedical Engineering
Worcester Polytechnic Institute
Worcester, Massachusetts, USA

Roger J. Hartman II (rogerh2) is kindly acknowledged for his advice in writing this analysis tool.
