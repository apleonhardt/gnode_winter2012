function [hh,xh] = PSTH(sptimes,trialids,b,T,option,filename,varargin)
% [hh,xh] = PSTH(sptimes,trialids,b,T,trialsel,option): make PSTH
%
% input:  sptimes: column vector containing spike times
%                  (unsorted possible)
%         trialids: column vector containg trial id per spike
%         b      : bin width in ms
%         T      : maximal duration in ms
%         trialsel: selected trial ids
%         option : 'exclusive' : exclusive binning 
%                   binsize b
%                  'convolution' : convolution
%                   with box-kernel of with b (in ms steps)
%
% output: hh     : rate vector (in units of 1/s)
%         xh     : time vector (in ms)
%
% (c) Sonja Gruen, 1999-2003
%     SG, 30.9.04, updated version

fac2s = 1/1000;

origtrialids = unique(trialids);
orig_ntrials = length(origtrialids);

% number of trials
if isempty(varargin)| isempty(varargin{1})
    trialsel = unique(trialids);
else
    [belong,tmpidx] = ismember(varargin{:},origtrialids);
    if ismember(0,belong)
        disp(['Warning in PSTH.m'])
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

% select spikes only from sepcific trials
selsptimes = [];
for ii=1:ntrials
    selsptimes = [selsptimes; sptimes(find(trialids==trialsel(ii)))];
end

switch option
    case 'exclusive'
        binnedtimeaxis = [0:b:T];
        [hh,xh] = hist(selsptimes, binnedtimeaxis);
        text    = ['binwidth: '];

    case 'convolve'
        
        % different kernels not implemented
        %switch kernel
        
        % base on data of 1ms time resolution
        binnedtimeaxis = [0:1:T];
        [hh1,xh] = hist(selsptimes, binnedtimeaxis);
        
        %case 'box'
        k = ones(1,b);
        %k = k/sum(k);
        nk = size(k,1);
        
        convdata = conv(k,hh1);
        tmpidx   = floor(nk/2)+1:length(hh1)+floor(nk/2);
        hh       = convdata(tmpidx);
        text     = ['boxkernel width: '];

    otherwise
        error('UnknownOption')
end    



%figure
% conversion to rates
hh = hh/(ntrials*b*fac2s);
stairs(xh,hh);

set(gca, 'Xlim', [0 T])
xlabel('time (ms)')
ylabel('\lambda (1/s)')
if isempty(varargin) | isempty(varargin{1})
   title(['PSTH of ' filename ' ; ' text num2str(b) ' ms'])
else
   title(['PSTH of ' filename ' ; ' text num2str(b) ' ms; ' num2str(ntrials) '/' num2str(orig_ntrials) ' trials selected' ])
   disp([ ]) 
   disp(['PSTH, selected trials: ']);
    disp(trialsel');
    disp([ ]);
end
drawnow;

