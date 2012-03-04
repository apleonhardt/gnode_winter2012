function MakeAnalysisSingleNeuron(filename,varargin)
% MakeAnalysisSingleNeuron(filename,varargin): creates
% a selection of analyses for a single neuron given
% by filename:
% 1. Dot Display
% 2. PSTH
% 3. Nr Spikes per Trial
% 4. Distribution of nr of spikes per trial
%    (includes the Fano Factor)
% 5. Inter-Spike-Interval Histogram
%    (included the Coefficient of Variation)
% 6. Auto-Correlogram
%
% input:
%       filename : name of data file 
%                  specification of format 
%                  see in LoadData.m)
%
%       varargin{1} : bin/kernelsize
%       varargin{2} : 'exclusive', 'convolve'
%       varargin{3} : trial selction
%
% (c) Sonja Gruen 1999-2004
%
% Example: MakeAnalysisSingleNeuron('Data13')
%          MakeAnalysisSingleNeuron('Data13', 10, 'exclusive')
%          MakeAnalysisSingleNeuron('Data13', 10, 'exclusive', [1:10])

if nargin < 1
    error(['MakeAnalysisSingleNeuron::NoInputFile'])
elseif nargin == 1 | nargin == 2
    varargin{3} = [];
    varargin{1} = 5;
    varargin{2} = 'exclusive';
    disp(['Warning::MakeAnalysisSingleNeuron::AssumesExclusiveBinning(b=5ms)']);
elseif nargin == 3
    varargin{3} = [];
end

%
% read data
% 
[sptimes,trialids,ntrials,T] = LoadData_Gnode(filename);

figure
set(gcf, 'Units', 'centimeters', 'Position', [1 1 15 20]);


%
% draw dot display
%
a1 = subplot('Position', [0.125 0.8 0.8 0.15]);
%set(gca, 'Units', 'normalized', 'Position', [0.1 0.1 0.85 0.95])
DotDisplay(sptimes,trialids,T,filename,varargin{3});
set(a1, 'Xticklabel', []);
xlabel([])
%set(gca, 'Units', 'normalized', 'Position', [0.1 0.8 0.85 0.1])

%
% draws PSTH
%
a2 = subplot('Position', [0.125 0.6 0.8 0.15]);
PSTH(sptimes,trialids,varargin{1},T,varargin{2},filename,varargin{3});

%
% calulate spike counts per trial
% and spike count distribution
%
a3 = subplot('Position', [0.125 0.35 0.325 0.15]);
SpikeCountPerTrial(sptimes,trialids,T,varargin{3});

a4 = subplot('Position', [0.6 0.35 0.325 0.15]);
SpikeCountDistr(sptimes,trialids,T,varargin{3});

%
% draw interspike interval distribution
% and calculate the coefficient of variation

a5 = subplot('Position', [0.125 0.1 0.325 0.15]);
InterSpikeIntervDistr(sptimes,trialids,T,varargin{3});

%
% draw autocorrelogram
%
a6 = subplot('Position', [0.6 0.1 0.325 0.15]);
[datatoplot,tautime,text,textylabel,datatoplot2] = ...
    CalcCCH(filename,filename,50,'raw',varargin{3});
%figure
PlotCCH(filename,filename,datatoplot,tautime,text,textylabel,datatoplot2);




