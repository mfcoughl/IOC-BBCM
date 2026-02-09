% Time_Series_Analysis.m
% -------------------------------------------------------------------------
%
% Minimal script to compute a per-image normalized mean intensity trace
% (whole-image mean divided by background ROI mean), plus a simple windowed
% step detector (“event metric”) on that trace.
%
% HOW TO USE
% 1) Place this script (Time_Series_Analysis.m) in the SAME folder as the
%    time-series images.
% 2) Run this script in MATLAB.
% 3) On the first image, draw a freehand BACKGROUND ROI.
% 4) The script plots:
%       (a) Mean intensity / background mean vs image number
%       (b) Normalized event metric vs image number
%
% NOTES
% - The background ROI mask is drawn on the first image and reused for all
%   images (same pixel coordinates).
% - Images are processed in the order returned by dir().
%
% REQUIREMENTS
% - MATLAB with Image Processing Toolbox (drawfreehand, createMask)
%
% -------------------------------------------------------------------------

clc; clear; close all;

% PARAMETERS
ext        = '.tif';

W         = 3;      % window size (frames)
doSmooth  = true;   % optional light smoothing
smoothWin = 3;      % smoothing window (frames)

% 1) Get file list (from current folder)
folderPath = pwd;
files = dir(fullfile(folderPath, ['*' ext]));

imnum    = numel(files);
imagepos = 1:imnum;

% 2) Load first image and select BACKGROUND ROI
im1  = imread(fullfile(folderPath, files(1).name));
im1d = double(im1);

figure('Name','Select BACKGROUND ROI on first image');
imagesc(im1d); axis image; colormap gray;
title('Draw BACKGROUND ROI (freehand)');
hbg    = drawfreehand();
bgMask = createMask(hbg);
close(gcf);

% 3) Compute mean normalized intensity trace
meanNorm = zeros(1, imnum);

for i = 1:imnum
    im  = imread(fullfile(folderPath, files(i).name));
    imd = double(im);

    bgMean = mean(imd(bgMask));
    imMean = mean(imd(:));

    meanNorm(i) = imMean / bgMean;
end

% 4) Plot: average normalized intensity vs image number
figure
plot(imagepos, meanNorm, '-o')
xlabel('Image number')
ylabel('Mean intensity / background mean')
title('Average normalized intensity vs image number')
grid on

% 5) Event metric on normalized trace
S = meanNorm(:);
t = imagepos(:);

if doSmooth
    Suse = movmean(S, smoothWin);
else
    Suse = S;
end

eventMetric = nan(size(Suse));
for i = (W+1):(numel(Suse)-W)
    pre  = mean(Suse(i-W:i-1));
    post = mean(Suse(i+1:i+W));
    eventMetric(i) = -(post - pre);
end

eventMetricNorm = eventMetric / max(eventMetric, [], 'omitnan');

% 6) Plot: event metric
figure
plot(t, eventMetricNorm, '-o')
xlabel('Image number')
ylabel('Event metric (normalized)')
title(sprintf('Windowed step detector on normalized trace (W = %d)', W))
grid on
