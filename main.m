%% read input image
close all;
A = imread('plant001_rgb.png');
%A = imread('plant017_rgb.png');
%A = imread('plant223_rgb.png');

% get the size of the image
height = size(A,1);
width = size(A,2);

area = height * width;
%% super pixels

% divide the image into 150 super pixels
[labels,num_labels] = superpixels(A,150);

BW = boundarymask(labels);
figure;
imshow(imoverlay(A,BW,'cyan'),'InitialMagnification',67);
impixelinfo;

% uncomment to save the results of superpixels
% fig=gcf;                                     
% fig.PaperPositionMode='auto';
% print('Superpixels','-dpng','-r0');




%% average pixels in superpixels

average = zeros(size(A),'like',A);
idx = label2idx(labels);

% unify pixels within superpixels by taking the mean in GRB
for labelVal = 1:num_labels
    
    redIdx = idx{labelVal};
    average(redIdx) = mean(A(redIdx));
    
    greenIdx = idx{labelVal}+area;
    average(greenIdx) = mean(A(greenIdx));
    
    blueIdx = idx{labelVal}+2*area;
    average(blueIdx) = mean(A(blueIdx));
    
end

figure;
imshow(average);
impixelinfo;

% uncomment to save the results of averaged superpixels
% fig=gcf;                                     
% fig.PaperPositionMode='auto';
% print('Average1','-dpng','-r0');
%% thresholding

% RGB color space of unified image
aR = average(:,:,1);
aG = average(:,:,2);
aB = average(:,:,3);

% first thresholding to select green plants
greenness = (aG-aR>=20 & aG-aB>=20);


% eliminate noise
greenness(aG>=170 & aR >=170 & aB>=170) = 0;

figure
imshow(greenness);

% uncomment to save the results of averaged superpixels

impixelinfo;
fig=gcf;                                     
fig.PaperPositionMode='auto';
print('T41','-dpng','-r0');

%% Binary image processing

% calculate structure element size
seSize = floor(sqrt(width*height)/250); 
seSize=10;
% open
se = strel('sphere',seSize);
output = imclose(greenness,se);


figure;
imshow(output);
title('afterClosing');

% uncomment to save the final result
fig=gcf;                                     
fig.PaperPositionMode='auto';
print('Final result21','-dpng','-r0');