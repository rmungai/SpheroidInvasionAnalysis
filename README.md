
# SpheroidInvasionAnalysis


**Corresponding manuscript:** "Towards an Objective and High-throughput Quantification Method for Spheroid Invasion Assays" Rozanne W. Mungai, Roger J. Hartman, Grace Jolin, Kevin Piskorowski , and Kristen L. Billiar. 
  * **DOI** *(will be added after publication, currently in peer-review)*
  * Please cite the above manuscript if you use these scripts in your research.


This repository contains **MATLAB** scripts used to batch process images of multicellular spheroids and quantify invasion between two snapshot images. It is intended for cases where the same spheroid is imaged at an initial timepoint (such as Day 0, when no invasion has occured) and again imaged at a final timepoint (such as Day 2) to calculate the extent of invasion from the spheroid. Please see the corresponding manuscript for a use-case example.

A GUI (for those unfamiliar with programming) and a Python version of these scripts are provided by @rogerh2 for ease of use. https://github.com/rogerh2/SpheroidInvasionAnalysis 

## **Requirements**
MATLAB R2021a or later with the image processing toolbox

## **Components**

Use `Binarizing_imageset_two step.m` to automatically binarize gray scale 8-bit .tif images and apply a circular mask around the image edges. 

(MAIN) Use `Quant_imageset.m` to quantify invasion using two sets of images per spheroid: (1) initial and (2) final time points. 
**Note:** Rather than using object-based image segmentation, this method is pixel-based.

Use `ConsolidateData2.m` to compile the data from all spheroids processed in `Quant_imageset.m` into one file for easier organization.
<br>
<br>

## **Pipeline**

### STEP 1:
`Binarizing_imageset_two step.m` This script takes in grayscale 8-bit .tif images and semi-automatically binarizes all images in a given folder with a for loop. It binarizes the images using the `imbinarize(I,T)` function with a user-determined global threshold value (default is currently set to 0.16, from a range [0, 1]). A circular mask is applied around the spheroids for quantification consistency since, in cases of abundant invasion, the rectangular image frame can skew invasion results towards the long image axis. Manual image correction is provided as an option in case further image processing is needed. User input is required to determine if each binarized image is satisfactory or if manual correction is desired. This script is *optional* since binarizing and masking can be performed externally if desired (such as with FIJI). It is recommended that contrast enhancing is performed before running this script to simplify automatic binarization.

Inputs: Grayscale 8-bit tif images

Outputs: Binarized tif images (masked and unmasked)
    * a ".pdf" file containing all figures

Function tree:
  * `Binarize_image.m`
  * `Correct_BW.m`
  * `Mask_Image_wCentroid.m`
  * `Find_SpheroidCentroid.m`
<br>

 ### STEP 2: (MAIN)
Use `Quant_imageset.m` to quantify invasion using two sets of images per spheroid: (1) initial and (2) final time points. 

Takes in binarized images from a given folder and automatically traces the boundary of the initial (aka. Day 0) image and overlays that boundary over the final time point image. The distances and angles of all pixels (aka. cells) at the final time point that have invaded past the boudary are automatically calculated in reference to both the boundary as well as the center of the spheroid *(see Figure 1 in corresponding publication)*. Next, invasion metrics are calculated: area change, distance from boundary and center, area moment of inertia. This process is fully automatic as the boundary tracing and calculations are performed in a for loop for all the immages in the given folder. The variables are saved in a ".mat" file and the figures are saved as ".fig" files as well as compiled into a pdf document.  

The binarized images used should be circle-masked annd there must be a clear boundary on the initial (aka Day 0) images to accomodate boundary tracing (as in, no stray pixels in the image). Therefore, we recommend using the provided `Binarizing_imageset_two step.m` to generate the binarized and circle-masked images. 

To accomodate automatic file saving, keep track of the spheroids by number and note the number in the beginning of the image name followed by an underscore such as: [Spheroid #]_[...]
Example: "1_day0_maskedBW_E1.tif"

Inputs: Binarized images: Initial Timepoint, Final Timepoint

Outputs: ".mat" file per each spheroid containing invasion calculations including the following metrics: area change, distance from the boundary and center, area moment of inertia
    * ".fig" files and a ".pdf" file containing all figures
    
Function tree:
  * `Find_Boundary_BWonly.m`
  * `Find_SpheroidCentroid.m`
  * `FEprops.m`
  * `AlignCentroidsandFindPixelsPOI.m`
  * `CalculateDistances.m`
  * `IntersectionDistance.m`
  * `FIndPixelAngles.m`
  * `PlotPixelDistancesandAngles.m`

It is recommended to run this script on images from one experiment condition at a time for easier organization.
<br> 
<br> 

### STEP 3:
Use **ConsolidateData.m**, *if desired*, to automatically compile the data obtained in "Quant_imageset.m" for each spheroid into one ".mat" file. The user selects the ".mat" files to consolidate and the script automatically loops through them to consolidate them into one file. For best results, "Quant_imageset.m" should be run on images from one experiment condition at a time, so the output .mat file of "ConsolidateData.m" will contain all the spheroids of a single experiment condition. The consolidated data can then be extracted by the user for further organization and analysis as desired. 

Inputs: ".mat" files per spheroid containing invasion calculations including the following metrics: area change, distance from the boundary and center, area moment of inertia

Outputs: ".mat" file per user-defined group (such as an experiment condition) containing invasion calculations for all the spheroids in that group
<br>
<br> 

### STEP 4:
**PCA_script.m** performes Principle Component Analysis on the spheroid invasion data of one experiment in order to quantify invasion directionality trends. The user loads a ".mat" file that was saved using `ConsolidateData.m`. The script will automatically calculate the principle angles of invasion as well as transform the invasion distance along the principle angles and calculate the transformed area moment of inertia. The variables are saved in a ".mat" file and the figures are saved as ".fig" files as well as compiled into a pdf document.
  * Calls on `PerformPCA.m`

Inputs: ".mat" files per user-defined group (from STEP 3) 

Outputs: ".mat" files per group containing PCA invasion calculations, 
    * ".fig" files and a ".pdf" file containing all figures
<br>
<br> 

### BRANCHES:
MAIN branch contains all scripts for the main pixel-based analysis detailed in the manuscript. The branches `QUANTIFYING_NUCLEI_CENTROIDS` and `TESTING_BINARIZING_THRESHOLD_ONPIXELS` contain the scripts used to compare the effect of thresholding on the quantified invasion metrics for the object-based and pixel-based methods respectively. To perform this analysis, the `QuickQuant.m` script can be used to more easily load and save variables for running the `Quant_imageset.m` script. 
<br>
<br> 

## Author info

**Rozanne W. Mungai**, 
Department of Biomedical Engineering,
Worcester Polytechnic Institute,
Worcester, Massachusetts, USA


Roger J. Hartman II (rogerh2) is kindly acknowledged for his advice in writing this MATLAB-based analysis tool. 



