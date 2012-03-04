function CalcSpikeCounts(filename,varargin)
% CalcSpikeCounts(filename,varargin)
% program that reads the data file specified
% by filename (see details in LoadData.m),
% displays spike counts per trial
% and the spike count distribution of spike
% counts from many trials.
% Computes the Fano Factor.
%
%  input:
%    filename     : filename of data
%                  (specifications: see LoadData.m)
%    varargin     : optional: selection of trial ids
%
%
% output: 
%         creates a plot 
%
% Calls: LoadData.m
%        SpikeCountPerTrial.m
%        SpikeCountDistr.m
%
% (c) Sonja Gruen, 1999-2004
% 
% Examples:
%
%   CalcSpikeCounts('Data10')
%

%
% read data
% 
[sptimes,trialids,ntrials,T] = LoadData(filename);

%
% calulate spike counts per trial
% and spike count distribution
%

figure

subplot(2,1,1)
SpikeCountPerTrial(sptimes,trialids,T,varargin{:});

subplot(2,1,2)
SpikeCountDistr(sptimes,trialids,T,varargin{:});
