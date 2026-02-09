# Time-Series Analysis MATLAB Script

This repository provides the MATLAB script used in our manuscript submission to compute a normalized mean intensity trace from a BBCM time series and a simple windowed step detector (“event metric”) on that trace.

## Contents
- **Time_Series_Analysis.m**: computes the per-image normalized mean intensity trace (whole-image mean divided by background ROI mean) and a normalized event metric, and generates two plots.
- **Background_Example.png**: representative example showing how to select the background region of interest (ROI) used for normalization.

## How to Use
1. **Download or clone this repository**, and place **Time_Series_Analysis.m** in the **same folder** as the time-series images (`.tif`).
2. Open MATLAB, set the Current Folder to that image folder, and run:
   - `Time_Series_Analysis.m`
3. When the first image appears, draw a freehand **BACKGROUND ROI** (an empty region with no cells/structures).
4. The script will generate:
   - **Plot 1:** Mean intensity / background mean vs image number  
   - **Plot 2:** Event metric (normalized) vs image number

The `.tif` image sequences are hosted separately on Figshare.

## Notes
- The background ROI is drawn on the first image and reused for all images (same pixel coordinates).
- Images are processed in the order returned by `dir()`.

## Requirements
- MATLAB with Image Processing Toolbox (`drawfreehand`, `createMask`)

## Citation
If you use this script, please cite the corresponding manuscript once published.
