% Modified version of the auto-generated script by cameraCalibrator app.
% Type cameraCalibrator on the MATLAB command line if you want to use the 
% original app.
% See https://www.mathworks.com/help/vision/ref/cameracalibrator-app.html
% -------------------------------------------------------


%% Define checkerboard size
squareSize = 25;  % mm

%% Define images to process

% Set manually
% imageFileNames = {
%     './data/IMG_001.jpg',...
%     './data/IMG_002.jpg',...
%     };
% 

% Set automatically
img_file_list = dir('data/*.jpg');
num_img_files = size(img_file_list, 1);

imageFileNames = cell(1, num_img_files);
for i=1:num_img_files
    imageFileNames(1, i) = {[img_file_list(i,1).folder '/' img_file_list(i,1).name]};
end


%% Detect checkerboard corners in images
detector = vision.calibration.monocular.CheckerboardDetector();
[imagePoints, imagesUsed] = detectPatternPoints(detector, imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates for the planar pattern keypoints
worldPoints = generateWorldPoints(detector, 'SquareSize', squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% View reprojection errors
h1=figure; showReprojectionErrors(cameraParams);

% Visualize pattern locations
h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, cameraParams);

% undistortedImage = undistortImage(originalImage, cameraParams);
