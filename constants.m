%% Used for storing constants used in mag_cal.m
% Author : Kritik Soman
% Time of creation : 24 Nov 2016, 8:30pm

classdef constants
    %% Stored separately so that changes in calibration can be made easily
    
    properties (Constant)
        buffSize=45;% size of buffer used for calibration
        minDev=20;% minimum magnetometer data variance so that it can be added in buffer 
        minCalLen=30;% minimum length of buffer so that calibration is attempted
        minDelta=20;% minimum change in x,y or z coordinate so that calibration is attempted
        maxDelta=150;% maximum change in x,y or z coordinate so that calibration is attempted
        minRadius=25;% minimum radius of acceptable sphere fitting
        maxRadius=55;% maximum radius of acceptable sphere fitting
        maxResidue=0.1;% maximum residue of acceptable sphere fitting
    end
end