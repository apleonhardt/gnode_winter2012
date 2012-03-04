function MakeDotDisplay(filename,varargin)
% MakeDotDisplay(filename,varargin): 
% program that reads the data file specified
% by filename and displays a dot display using 
% DotDisplay.m
%
% input:
%     filename: name of input data file
%               (see format details in LoadData.m)
%     varargin: may contain selected trial ids
%               as a vector
%
% output: creates dot display plot 
%
% (c) Sonja Gruen, 1999-2003
%     SG, 30.9.04 
%     updated to allow
%     for variable trial select input
%     (varagin) and requires file name
%     now.
% 
%
% output: creates a plot 
%
% Calls: LoadData.m
%        DotDisplay.m
%
% (c) Sonja Gruen, 1999-2004
%
% Example: MakeDotDisplay('Data24', [1:10])


%
% read data
% 
[sptimes,trialids,ntrials,T] = LoadData(filename);

%
% draws the dot display
%
figure
set(gcf, 'Units', 'centimeters', 'Position', [1 15 15 5]);
subplot('Position', [0.1 0.2 0.8 0.6])
DotDisplay(sptimes,trialids,T,filename,varargin{:});


