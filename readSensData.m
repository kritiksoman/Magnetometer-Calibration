function [x,y,z,t] = readSensData(filename, startRow, endRow)

%%*************Function to read sensor data from text file*****************
% Author : Kritik Soman
% Time of creation : 24 Nov 2016, 8:30pm
%Import numeric data from a text file as column vectors.
%   [X,Y,Z,T] = readSensData(FILENAME) Reads data from text file FILENAME
%   for the default selection.
%
%   [X,Y,Z,T] = readSensData(FILENAME, STARTROW, ENDROW) Reads data from
%   rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   [x,y,z,t] = readSensData('data_acc.txt',2, 2544);
% Auto-generated by MATLAB on 2016/11/24 13:40:08
%%*************************************************************************

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)

formatSpec = '%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.

dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.

fclose(fileID);

%% Allocate imported array to column variable names

x = dataArray{:, 1};
y = dataArray{:, 2};
z = dataArray{:, 3};
t = dataArray{:, 4};
end