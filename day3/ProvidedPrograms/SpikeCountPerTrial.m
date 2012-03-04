function [nspikes,trialsel] = SpikeCountPerTrial(sptimes,trialids,T,varargin)
% [nspikes,trialsel] = SpikeCountPerTrial(sptimes,trialids,T,trialsel)
%
% input:  sptimes: column vector containing spike times
%                  (unsorted possible)
%         trialids: column vector containg trial id per spike
%         T      : maximal duration in ms
%         trialsel: selected trial ids
%
% output: nspikes : number of spikes per trial
%         trialsel: corresponding (ordered) trial ids
%
% (c) Sonja Gruen, 1999-2003
%     SG, 1.10.04, updated
% 
origtrialids = unique(trialids);
orig_ntrials = length(origtrialids);

% number of trials
if isempty(varargin)| isempty(varargin{1})
    trialsel = unique(trialids);
else
    [belong,tmpidx] = ismember(varargin{:},origtrialids);
    if ismember(0,belong)
        disp(['Warning in SpikeCountPerTrial.m'])
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
nspikes = [];
for ii=1:ntrials
    nspikes(ii) = length(sptimes(find(trialids==trialsel(ii))));
end

%figure

%bar(trialsel, (nspikes/T)*1000);  % in sp/sec
bar(trialsel, nspikes);
set(gca, 'Xlim', [1 ntrials])
set(gca, 'Ylim', [0 max(nspikes)+5])

xlabel('trial id')
ylabel('spike count')
title(['Counts per Trial (T=' num2str(T) ' ms)'])
drawnow;

