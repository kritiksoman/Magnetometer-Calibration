# Magnetometer-Calibration
[![MIT](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/kritiksoman/Magnetometer-Calibration/blob/master/LICENSE)

A MEMS magnetometer present in a smartphone needs to be calibrated before using it to measure the magnetic field. As an example, the process is demonstrated in the following YouTube video:

[![Youtube Video](https://img.youtube.com/vi/OFF_nzIktRk/0.jpg)](https://www.youtube.com/watch?v=OFF_nzIktRk "Youtube Video")


# Overview
The algorithm running behind this application has been implemented here. As the user moves the mobile in the specific motion, the data from the magnetometer is fit into a sphere. The center of the sphere is then subtracted from the subsequent sensor data to get the calibrated values. 

# Files
The following files/folders are present in this code: <br/>
[1] data : this folder contains the data from all the sensors, namely, magnetometer and accelerometer.<br/>
[2] mag_cal.m : this script performs calibration and produces 3 plots. The first one shows the rolling pebble as in the video, the second one shows the sensor data being read, and the third one shows the sphere that was fit using the data.<br/>
[3] emptyBuffer.m : this function creates a buffer for storing data on which calibration is performed.<br/>
[4] readSensData.m : this function was auto generated from MATLAB to read sensor data from text files present inside data folder.<br/>
[5] sphereFit.m : this function fits a sphere into a set of points and returns the fitting parameters.<br/>
[6] constants.m : this file stores the constants used in “mag_cal.m”.<br/>

## Result Screenshot
![image1](https://github.com/kritiksoman/Magnetometer-Calibration/blob/master/results/mag_cal.png)

# Note
[1] Code was tested on MATLAB 2014b. <br/>
[2] Data was collected by using an application on play store. ([Link to app](https://play.google.com/store/apps/details?id=com.hfalan.activitylog&hl=en))
