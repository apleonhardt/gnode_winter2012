function [cdistr,xdistr,FF] = SpikeCountDistr(sptimes,trialids,T,varargin)
% [nspikes,trialsel,FF] = SpikeCountDistr(sptimes,trialids,T,trialsel)
%
% input:  sptimes: column vector containing spike times
%                  (unsorted possible)
%         trialids: column vector containg trial id per spike
%         T      : maximal duration in ms
%         trialsel: selected trial ids
%
% output: nspikes : number of spikes per trial
%         trialsel: corresponding (ordered) trial ids
%               FF: Fano Factor 
%                   (variance of spike counts/ mean of spike counts)
%
% (c) Sonja Gruen, 1999-2003
%     SG, 1.10.04, updated
%

origtrialids = unique(trialids);
orig_ntrials = length(origtrialids);

% number of trials
if isempty(varargin) | isempty(varargin{1})
    trialsel = unique(trialids);
else
    [belong,tmpidx] = ismember(varargin{:},origtrialids);
    if ismember(0,belong)
        disp(['Warning in SpikeCountDistr.m'])
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

FF = var(nspikes)/mean(nspikes);

%figure

[cdistr,xdistr] = hist(nspikes,[min(nspikes)-2:1:max(nspikes)+2]);

stairs(xdistr, cdistr)
%grid on
set(gca, 'Xlim', [min(nspikes)-2 max(nspikes)+2], 'Ylim', [0 max(cdistr)+2])
xlabel('spike count')
ylabel('# counts')
title(['Count Distribution; FF=' num2str(FF)])
drawnow;

