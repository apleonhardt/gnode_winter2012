function MakeCCH(filename1,filename2,maxlag,varargin)
% [cch,lags] = CCH(sptimes1,trialids1,sptimes2,trialids2,T,trialsel1,trialsel2,maxlag,option)
%
% input: 
%   filename1 : name of Data file 1
%   filename2 : name of Data file 2
%   maxlag    : maximal time lag for CCH computation
%               (in ms, assumes time resolution of 1 ms)
%   varargin{1}: optional: analysis options for CCH calculation
%            'raw'    : draws a raw cross-correlogram with 
%                       counts normalized to the number of trials
%            'rawpred': draws the raw cross-correlogram
%                       and in addition the psth-predictor
%                       (in red)
%            'rawshuff': draws the raw cross-correlogram
%                       and in addition the shuffle-predictor
%                       (one random shuffle, no identical trial-trial
%                       ids in the shuffle)
%                       (drawn in red)
%            'cov'     : draws the cross-covariance, i.e.
%                        raw cross-correlogram - psth-predictor
%            'coeff'   : draws the CCH expresses as the 
%                        correlation coefficient 
%                        i.e. cross-covariance / CCH(std_psth1,std_psth2)
%                        (see for details crossprog.m)
%              default is 'raw'
%   varargin{2}: optional: trialselection
%
% 
% output: generates CCH-plot
%
% Uses: crosscorr.m
%       crossprog.m
%
% (c) Sonja Gruen, 1999-2004
% 

% calculate CCH
if nargin < 3
    error(['MakeCCH::NoMaxLagGiven'])
elseif nargin < 4
    varargin{1} = 'raw';
    varargin{2} = [];
    disp(['Warning::MakeCCH::NoOptionGivenCalculatesRawCrossCorrelogram']);
elseif nargin == 4
    varargin{2} = [];
end

[datatoplot,tautime,text,textylabel,datatoplot2] = ...
    CalcCCH(filename1,filename2,maxlag,varargin{1},varargin{2});


figure
PlotCCH(filename1,filename2,datatoplot,tautime,text,textylabel,datatoplot2);