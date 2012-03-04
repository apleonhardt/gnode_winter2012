function [isidistr,xdistr,CVpertrial,CVtot] = InterSpikeIntervDistr(sptimes,trialids,T,varargin)
% [isidistr,xdistr,CVpertrial,CVtot] = InterSpikeIntervDistr(sptimes,trialids,T,trialsel)
%
% input:  sptimes  : column vector containing spike times
%                  (unsorted possible)
%         trialids : column vector containg trial id per spike
%         T        : maximal duration in ms
%         varargin : optional: selected trial ids
%
% output: isidistr : interspike interval distr
%         xdistr   : corresponding isi values
%         CVpertrial: coefficient of variation 
%                     (std(ISI)/mean(ISI)) per trial
%         CVtot    : coefficient of variation (all trials)
%
% (c) Sonja Gruen, 1999-2003
% 

origtrialids = unique(trialids);
orig_ntrials = length(origtrialids);

% number of trials
if isempty(varargin) | isempty(varargin{1})
    trialsel = unique(trialids);
else
    [belong,tmpidx] = ismember(varargin{:},origtrialids);
    if ismember(0,belong)
        disp(['Warning in InterSpikeIntervDistr.m'])
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
isi        = [];
CVpertrial = [];
for ii=1:ntrials
    isipertrial    = diff(sptimes(find(trialids==trialsel(ii))))';
    CVpertrial(ii) = std(isipertrial)/mean(isipertrial);
    isi            = [isi isipertrial];
end
CVtot = std(isi)/mean(isi);

%figure

[isidistr,xdistr] = hist(isi,[0:1:max(isi)]);
stairs(xdistr, isidistr);
set(gca, 'Xlim', [0 max(isi)+2], 'Ylim', [0 max(isidistr)+2])

xlabel('ISI (ms)')
ylabel('# counts')
title(['ISI Distribution; CV=' num2str(CVtot) ])
drawnow