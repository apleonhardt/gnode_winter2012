function [datatoplot,tautime,text,textylabel,datatoplot2] = CalcCCH(filename1,filename2,maxlag,varargin)
% [datatoplot,tautime,text,textylabel,datatoplot2] =
%              CalcCCH(filename1,filename2,maxlag,varargin)
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
% output: 
%   [datatoplot,tautime,text,textylabel,datatoplot2]
%    for generating a plot
%
% Uses: crosscorr.m
%       crossprog.m
%
% (c) Sonja Gruen, 1999-2004
% 

% if nargin < 3
%     error(['MakeCCH::NoMaxLagGiven'])
% elseif nargin < 4
%     varargin{1} = 'raw';
%     varargin{2} = [];
%     disp(['Warning::MakeCCH::NoOptionGivenCalculatesRawCrossCorrelogram']);
% elseif nargin == 4
%     disp('hallo')
%     varargin{2} = [];
% end

% if isempty(varargin{1}) | varargin{1}==[]
%   varargin{1} = 'raw';
%   varargin{2} = [];
%   disp(['Warning::CalcCCH::NoOptionGiven::CalculatesRawCrossCorrelogram']);
% end


analysisoption = varargin{1};   % raw, covariance, corrcoeff
trialsel       = varargin{2};




%
% read data for both neurons 
% from two separarte data files
% 
[sptimes1,trialids1,ntrials1,T1] = LoadData_Gnode(filename1);

[sptimes2,trialids2,ntrials2,T2] = LoadData_Gnode(filename2);

origtrialids1 = unique(trialids1);
orig_ntrials1 = length(origtrialids1);

origtrialids2 = unique(trialids2);
orig_ntrials2 = length(origtrialids2);

% check also if trial ids correspond


if length(orig_ntrials1)~=length(orig_ntrials2)
    error('CalcCCH::NumberOfTrialsNotConsistentInBothDataFiles');
else
    origtrialids = origtrialids1;
    orig_ntrials = orig_ntrials1;
    trialids     = trialids1;
    T = T1;
end

% number of trials
if isempty(varargin) | isempty(varargin{2})
    trialsel = unique(trialids);
else
    [belong,tmpidx] = ismember(varargin{:},origtrialids);
    if ismember(0,belong)
        disp(['Warning in MakeCCH.m'])
        disp(['Trial ids were selected that are not included in the data.'])
        disp(['==> Only original trial ids are here included in the analysis.'])
        disp([' '])
        trialselidx = find(belong);
        trialsel = varargin{:}(trialselidx);
        trialsel = trialsel';
    else
      trialsel = varargin{:};
      trialsel = trialsel';
  end
    
end

trialsel = unique(trialsel);
ntrials  = length(unique(trialsel));


% select spikes only from specific trials
% and change format to (0,1)-matrix
sp1 = zeros(ntrials,T);
sp2 = zeros(ntrials,T);
for ii=1:ntrials
    sp1times = sptimes1(find(trialids1==trialsel(ii)));
    sp2times = sptimes2(find(trialids2==trialsel(ii)));
    sp1(ii,round(sp1times)) = 1;
    sp2(ii,round(sp2times)) = 1;
end

[cch,tautime,cchpred,cchcov,cchcoeff]=crossprog(sp1,sp2,maxlag);


switch analysisoption
    case 'raw'
        datatoplot = cch;
        datatoplot2 = [];
        textylabel = 'counts/ntrials';
        text       = 'raw'; %'raw, normalized to # trials';
    case 'rawpred'
        datatoplot = cch;
        datatoplot2 = cchpred;
        textylabel = 'counts/ntrials';
        text       = 'raw (blue), pred (red)';
    case 'rawshuff'
        shufftrials1 = randperm(ntrials);
        shufftrials2 = randperm(ntrials);
        while find(shufftrials1 == shufftrials2); 
          shufftrials1 = randperm(ntrials);
          shufftrials2 = randperm(ntrials);  
          disp('gleich'); 
        end
        datatoplot = cch;
        [datatoplot2]=crossprog(sp1(shufftrials1,:),sp2(shufftrials2,:),maxlag);
        textylabel = 'counts/ntrials';
        text       = 'raw (blue), shuffle (red)';
    case 'cov'
        datatoplot = cchcov;
        datatoplot2 = [];
        textylabel = '\Delta counts';
        text       = 'covariance';
    case 'coeff'
        datatoplot = cchcoeff;
        datatoplot2 = [];
        textylabel = '\rho';
        text       = 'corr. coeff.';
end

return
% this goes into a sepeparate figure

figure
% binning option not yet implemented

bar(tautime, datatoplot);
hold on

if exist('datatoplot2')
    plot(tautime,datatoplot2,'r')
end
plot(tautime,zeros(size(tautime)), 'k--')
hold off
set(gca, 'Xlim', [-max(tautime) max(tautime)]);

xlabel('\tau (ms)')
ylabel([textylabel])

if strcmp(filename1,filename2) == 1
  title(['ACH (' text '); ' filename1 ])
else
  title(['CCH (' text '); ' filename1 ' vs ' filename2])
end
hold off
drawnow