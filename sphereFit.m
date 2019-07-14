function [center,radius,residue] = sphereFit(x,y,z)

%%****************Function to fit a sphere into 3d points******************
%   Author : Kritik Soman
%   Time of creation : 24 Nov 2016, 8:30pm
%   Call example :
%   [center,radius,residue] = sphereFit(x,y,z);
%   Input : x,y and z should be of same length
%   x : coloumn vector containing x coordinate 
%   y : coloumn vector containing y coordinate
%   z : coloumn vector containing z coordinate
%   Output :
%   center : row vector [x0 y0 z0] containing center of fitted sphere
%   radius : radius of fitted sphere
%   residue : row vector [x0 y0 z0] containing center of fitted sphere
%%*************************************************************************

%% All input vectors must be of same length

if length(x) ~= length(y) || length(y) ~= length(z) || length(x) ~= length(z)
    error('sphereFit:UnequalDataLength','All input vectors must be of same length.');
end

%% Need four or more data points

if length(x) < 4
    error('sphereFit:InsufficientData','At least four points are required to fit a unique sphere.');
end

%% Fit sphere

A = [x, y, z, ones(size(x))];
b = -(x.^2 + y.^2 + z.^2);
a = A \ b;

%% Calculate parameters

center = -a(1:3)./2;
radius = realsqrt(sum(center.^2)-a(4));
residue = radius - sqrt(sum(bsxfun(@minus,[x y z],center.').^2,2));
residue = mean(residue);
end