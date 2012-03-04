function [data,time]=EX_boxcar(data,TimeUnitsMS,WindowWidthMS)
% [data,time]=EX_boxcar(data,TimeUnitsMS,WindowWidthMS)
%
% This function performs a boxcar convoluton, or equivalently, a moving
% wondow average. Convolution is performed for all columns of a 1-3D array 
% along the 1st dimenson.
%
%
% input
%   data    :   spike matrix of size n x 1, n x m, or n x m x l
%               dim 1 : time 
%               dim 2 : trial or channel
%               dim 3 : trial or channel
%
% TimeUnitsMS   :   resoluton of spike matrix relative to milliseconds MS   
% WindowWidthMS :   width of boxcar window in milliseconds MS
%
% 1 - construct boxcar kernel (alternatively use : kernel_make_L.m)
w=floor(WindowWidthMS/TimeUnitsMS);
boxcar=ones(w,1);
% 2 - filter time series (alternatively use : ADF_convolution.m)
data=filter(boxcar,1,data);
data=data(w+1:end,:);
% 3 - normalize to firing rate in units of 1/s = Hz
data=data/w*1000;
time=(1:length(data))+floor(w/2);
time=time*TimeUnitsMS;
