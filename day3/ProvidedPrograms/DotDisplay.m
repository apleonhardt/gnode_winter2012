function DotDisplay(sptimes,trialids,T,filename,varargin)
% DotDisplay(sptimes,trialids,T,trialsel): make DotDisplay
%
% input:  sptimes: column vector containing spike times
%                  (unsorted possible)
%         trialids: column vector containg trial id per spike
%         T      : maximal duration in ms
%         filename: strin to be written in the title
%         varargin: may contain selected trial ids
%                   as a vector (former trialsel)
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

origtrialids = unique(trialids);
orig_ntrials = length(origtrialids);

% number of trials
if isempty(varargin) | isempty(varargin{1})
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
selsptimes = [];
seltrialids= [];
for ii=1:ntrials
    selsptimes = [selsptimes; sptimes(find(trialids==trialsel(ii)))];
    seltrialids= [seltrialids; trialids(find(trialids==trialsel(ii)))];
end


%figure

%plot(sptimes,trialids, 'k.','MarkerSize',3)       % plot all spikes
plot(selsptimes,seltrialids, 'k.','MarkerSize',3)  % plot selected trials

set(gca, 'Xlim', [0 T], 'Ylim', [0 max(unique(trialsel))+1])
xlabel('time (ms)')
ylabel('trial id')
  title(['Dot-Display of ' filename])
drawnow;

