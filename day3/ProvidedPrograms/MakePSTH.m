function MakePSTH(filename,kernelbinsize,option,varargin)
% [hh,xh] = MakePSTH(filename,varargin): 
% program that reads the data file specified
% by filename (see details in LoadData.m)
% and displays a psth using PSTH.m
%
%  input:
%    filename     : filename of data
%                  (specifications: see LoadData.m)
%   kernelbinsize : - in case of exclusive binning 
%                     (option == 'exclusive'): 
%                      bin size in ms
%                   - in case of convolution with
%                     a boxkernel (option == 'convolution'):
%                     kernelsize
%    option       : 'exclusive' : exclusive binning 
%                    with a binwidth of kernelbinsize
%                   'convolution' : convolution
%                    with boxkernel of width kernelbinsize
%                    (in steps of the time resolution of the data)
%                 
%    varargin     : optional: selection of trial ids
%
%
% output: % hh     : rate vector (in units of 1/s)
%         % xh     : time vector (in ms)
%         creates a plot 
%
% Calls: LoadData.m
%        PSTH.m
%
% (c) Sonja Gruen, 1999-2004
% 
% Examples:
%    MakePSTH('Data1',10,'convolve')
%
%    MakePSTH('Data1',10,'exclusive')
%
%    MakePSTH('Data1',10,'convolve', [1:10])
%

%
% read data
% 
[sptimes,trialids,ntrials,T] = LoadData(filename);

%
% draws PSTH
%
figure
[hh,xh] = PSTH(sptimes,trialids,kernelbinsize,T,option,filename,varargin{:});


